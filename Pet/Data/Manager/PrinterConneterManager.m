//
//  PrinterConneterManager.m
//  Pet
//
//  Created by mac on 2020/1/21.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "PrinterConneterManager.h"
#import "BluetoothListController.h"
#import "TscCommand.h"

@interface PrinterConneterManager ()
@property (nonatomic, strong) BLEConnecter *bleConnecter; // 蓝牙连接器
@property (nonatomic, strong) EthernetConnecter *ethernetConnecter; // 以太网连接器
@property (nonatomic, strong) Connecter *connecter; // 当前使用连接器
@property (nonatomic, assign) ConnectMethod currentConnMethod; // 当前连接方法

@property (nonatomic, strong) CBPeripheral * peripheral; // 选中的设备
@property (nonatomic, strong) NSMutableDictionary * scanResultDict; // 扫描到的设备存储字典
@property (nonatomic, assign) ConnectState connectState; // 连接状态
@end

static NSString * PrinterConnectStateChangeNotificationName = @"PrinterConnectStateChange";
static NSString * PrinterConnectStateKey = @"PrinterConnectState";

@implementation PrinterConneterManager

#pragma mark - life cycle

SingleImplementation(PrinterConneterManager)

/**
 初始化

 @return PrinterConneterManager
 */
-(instancetype)init{
    self = [super init];
    if (self) {
        self.connectState = NOT_FOUND_DEVICE;
    }
    return self;
}

/**
 * 初始化连接器
 * @param connectMethod 连接方法
 */
-(void)initConnecter:(ConnectMethod)connectMethod {
    switch (connectMethod) {
        case BLUETOOTH:
        {
            self.bleConnecter = [BLEConnecter new];
            self.connecter = self.bleConnecter;
        }
            break;
        case ETHERNET:
        {
            self.ethernetConnecter = [EthernetConnecter new];
            self.connecter = self.ethernetConnecter;
        }
            break;
        default:
            break;
    }
}

/**
 获取要打印的订单数据

 @param orderEntity 订单
 @return 用于打印的Data
 */
-(NSData *)getPrinterDataFromOrder:(OrderEntity *)orderEntity{
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:76 :182]; // 标签尺寸
    [command addGapWithM:0 withN:0]; // 标签间隙尺寸 单位mm
    [command addReference:0 :0]; // 设置标签原点坐标
    [command addTear:@"ON"]; // 设置打印机撕离模式
    [command addQueryPrinterStatus:ON]; // 打印机打印完成时，自动返回状态。可用于实现连续打印功能
    [command addCls]; // 清除打印缓冲区
    /**
     * 方法说明:在标签上绘制文字
     * @param x 横坐标
     * @param y 纵坐标
     * @param font  字体类型
     * @param rotation  旋转角度
     * @param xScal  横向放大
     * @param yScal  纵向放大
     * @param text   文字字符串
     */
    [command addTextwithX:50 withY:256 withFont:@"TSS48.BF2" withRotation:0 withXscal:1 withYscal:1 withText:orderEntity.startCity]; // 开始城市
    
    [command addTextwithX:250 withY:248 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:orderEntity.transport.transportTypeName]; // 运输方式
    
    [command addTextwithX:350 withY:256 withFont:@"TSS48.BF2" withRotation:0 withXscal:1 withYscal:1 withText:orderEntity.endCity]; // 结束城市
    
    [command addTextwithX:186 withY:360 withFont:@"TSS32.BF2" withRotation:0 withXscal:1 withYscal:1 withText:orderEntity.orderNo]; // 订单号
    
    [command addTextwithX:186 withY:432 withFont:@"TSS32.BF2" withRotation:0 withXscal:1 withYscal:1 withText:orderEntity.outportTime]; // 离港时间
    
    [command addTextwithX:122 withY:504 withFont:@"TSS32.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"%@ -- %@",orderEntity.petType.petTypeName,orderEntity.petBreed.petBreedName]]; // 宠物类型 和 宠物品种
    
    [command addTextwithX:122 withY:570 withFont:@"TSS32.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"%ld",orderEntity.num]]; // 宠物数量
    
    [command addTextwithX:386 withY:570 withFont:@"TSS32.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"%.1fkg",orderEntity.weight]]; // 宠物重量
    
    [command addTextwithX:186 withY:1384 withFont:@"TSS32.BF2" withRotation:0 withXscal:1 withYscal:1 withText:orderEntity.orderNo];
    // 绘制条形码
    //    [command add1DBarcode:30 :30 :@"CODE128" :100 :1 :0 :2 :2 :@"1234567890"];
    // 绘制二维码
    [command addQRCode:350 :637 :@"L" :5 :@"A" :0 :[NSString stringWithFormat:@"https://www.taochonghui.com/weapp/jump/confirm/order?type=scan&orderno=%@",orderEntity.orderNo] ];
    [command addQRCode:350 :1074 :@"L" :7 :@"A" :0 :@"https://www.taochonghui.com/weapp/jump/index"];
    // 执行打印
    [command addPrint:1 :1];
    return [command getCommand];
}

/**
 点击打印 开始打印

 @param orderEntity 需要打印的单据
 */
-(void)startPrinter:(OrderEntity * )orderEntity{
    __weak typeof(self)weakSelf = self;
    // 检查蓝牙状态 是否可使用蓝牙设备
    [[PrinterConneterManager sharePrinterConneterManager] checkBluetoothState:^(BOOL ableUse) {
        UIViewController * currentVC = Util_GetCurrentVC;
        // 允许使用
        if (ableUse) {
            // 是否已链接蓝牙设备
            // 已连接 显示打印及重选打印机 选项
            // 未连接 显示选择打印机 选项
            
            if (weakSelf.hasConnectPrinter) {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"已链接打印机" message:[[PrinterConneterManager sharePrinterConneterManager] getPeripheralName] preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction * printerAction = [UIAlertAction actionWithTitle:@"打印" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [MBProgressHUD showActivityMessageInWindow:@"打印中..."];
                    [[PrinterConneterManager sharePrinterConneterManager] write:[weakSelf getPrinterDataFromOrder:orderEntity] progress:^(NSUInteger total, NSUInteger progress) {
                        if (progress == 100) {
                            [MBProgressHUD hideHUD];
                        }
                    } receCallBack:^(NSData * _Nullable receCallData) {
                        
                    }];
                }];
                UIAlertAction * choosePrinterAction = [UIAlertAction actionWithTitle:@"重选打印机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    BluetoothListController * bluetoothListController = [[BluetoothListController alloc]init];
                    if (currentVC.navigationController!=nil) {
                        [currentVC.navigationController pushViewController:bluetoothListController animated:YES];
                    } else {
                        [currentVC presentViewController:bluetoothListController animated:YES completion:nil];
                    }
                }];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:printerAction];
                [alertController addAction:choosePrinterAction];
                [alertController addAction:cancelAction];
                [currentVC presentViewController:alertController animated:YES completion:nil];
            } else {
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"已链接打印机" message:[[PrinterConneterManager sharePrinterConneterManager] getPeripheralName] preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction * choosePrinterAction = [UIAlertAction actionWithTitle:@"选择打印机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    BluetoothListController * bluetoothListController = [[BluetoothListController alloc]init];
                    if (currentVC.navigationController!=nil) {
                        [currentVC.navigationController pushViewController:bluetoothListController animated:YES];
                    } else {
                        [currentVC presentViewController:bluetoothListController animated:YES completion:nil];
                    }
                }];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:choosePrinterAction];
                [alertController addAction:cancelAction];
                [currentVC presentViewController:alertController animated:YES completion:nil];
            }
        }
    }];
}

#pragma mark - bluetooth

/**
 *  获取外设设备
 *  @param serviceUUIDs 需要发现外设的UUID，设置为nil则发现周围所有外设
 *  @param options  其它可选操作
 *  @param resultCallback 结果回调
 */
-(void)getPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs options:(nullable NSDictionary<NSString *, id> *)options resultCallback:(void(^_Nullable)(NSDictionary* resultDict))resultCallback{
    __weak typeof(self) weakSelf = self;
    if (resultCallback){
        resultCallback(self.scanResultDict);
    }
    [self.bleConnecter scanForPeripheralsWithServices:serviceUUIDs options:options discover:^(CBPeripheral * _Nullable peripheral, NSDictionary<NSString *,id> * _Nullable advertisementData, NSNumber * _Nullable RSSI) {
        if (peripheral.name != nil && ![weakSelf.scanResultDict.allKeys containsObject:peripheral.identifier.UUIDString]) {
            NSLog(@"name -> %@", peripheral.name);
            [weakSelf.scanResultDict setObject:peripheral forKey:peripheral.identifier.UUIDString];
            if (resultCallback) {
                resultCallback(weakSelf.scanResultDict);
            }
        }
    }];
}

/**
 *  方法说明：扫描外设
 *  @param serviceUUIDs 需要发现外设的UUID，设置为nil则发现周围所有外设
 *  @param options  其它可选操作
 *  @param discover 发现的设备
 */
-(void)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs options:(nullable NSDictionary<NSString *, id> *)options discover:(void(^_Nullable)(CBPeripheral *_Nullable peripheral,NSDictionary<NSString *, id> *_Nullable advertisementData,NSNumber *_Nullable RSSI))discover{
    [self.bleConnecter scanForPeripheralsWithServices:serviceUUIDs options:options discover:discover];
}

/**
 *  方法说明：更新蓝牙状态
 *  @param state 蓝牙状态
 */
-(void)didUpdateState:(void(^)(NSInteger state))state {
    if (self.bleConnecter == nil) {
        self.currentConnMethod = BLUETOOTH;
        [self initConnecter:self.currentConnMethod];
    }
    [self.bleConnecter didUpdateState:state];
}

- (void)getBluetoothPermissions:(void(^)(BOOL authorized))completion {
    CBPeripheralManagerAuthorizationStatus authStatus = [CBPeripheralManager authorizationStatus];
    if (authStatus == CBPeripheralManagerAuthorizationStatusNotDetermined) {
        CBCentralManager *cbManager = [[CBCentralManager alloc] init];
        [cbManager scanForPeripheralsWithServices:nil options:nil];
    } else if (authStatus == CBPeripheralManagerAuthorizationStatusAuthorized) {
        if (completion) {
            completion(YES);
        }
    } else {
        completion(NO);
    }
}
/**
 检查蓝牙状态

 @param ableUseCallback 蓝牙可用回调
 */
-(void)checkBluetoothState:(void(^)(BOOL ableUse))ableUseCallback{
    if (self.bleConnecter == nil) {
        self.currentConnMethod = BLUETOOTH;
        [self initConnecter:self.currentConnMethod];
    }
    [self.bleConnecter didUpdateState:^(NSInteger state) {
        switch (state) {
            case CBCentralManagerStateUnsupported:
            {
                MSLog(@"设备不支持");
                MSLog(@"The platform/hardware doesn't support Bluetooth Low Energy.");
                if(ableUseCallback){
                    ableUseCallback(NO);
                }
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"当前设备不支持蓝牙使用" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                UIViewController * currentController = Util_GetCurrentVC;
                [currentController presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case CBCentralManagerStateUnauthorized:
            {
                MSLog(@"蓝牙未授权");
                MSLog(@"The app is not authorized to use Bluetooth Low Energy.");
                if(ableUseCallback){
                    ableUseCallback(NO);
                }
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"未获蓝牙授权" message:@"请前往系统设置授权使用蓝牙以使用打印机" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                UIViewController * currentController = Util_GetCurrentVC;
                [currentController presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case CBCentralManagerStatePoweredOff:
            {
                MSLog(@"蓝牙已关闭");
                MSLog(@"Bluetooth is currently powered off.");
                if(ableUseCallback){
                    ableUseCallback(NO);
                }
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"蓝牙已关闭" message:@"请前往系统设置打开蓝牙以使用打印机" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                UIViewController * currentController = Util_GetCurrentVC;
                [currentController presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case CBCentralManagerStatePoweredOn:
            {
                MSLog(@"蓝牙可使用");
                MSLog(@"Bluetooth power on");
                if(ableUseCallback){
                    ableUseCallback(YES);
                }
            }
                break;
            case CBCentralManagerStateUnknown:
            default:
            {
                MSLog(@"未知状态");
                if(ableUseCallback){
                    ableUseCallback(NO);
                }
            }
                break;
        }
    }];
}

/**
 *  方法说明：停止扫描
 */
-(void)stopScan {
    [self.bleConnecter stopScan];
}

/**
 *  方法说明：连接外设
 *  @param peripheral 需连接的外设
 *  @param options 其它可选操作
 *  @param timeout 连接时间
 *  @param connectBlock 连接状态
 */
-(void)connectPeripheral:(CBPeripheral *)peripheral options:(nullable NSDictionary<NSString *,id> *)options timeout:(NSUInteger)timeout connectBlock:(void(^_Nullable)(ConnectState state)) connectBlock{
    self.peripheral = peripheral;
    [self.bleConnecter connectPeripheral:peripheral options:options timeout:timeout connectBlack:connectBlock];
}

/**
 *  方法说明：连接外设
 *  @param peripheral 需连接的外设
 *  @param options 其它可选操作
 */
-(void)connectPeripheral:(CBPeripheral * _Nullable)peripheral options:(nullable NSDictionary<NSString *,id> *)options {
    self.peripheral = peripheral;
    [self.bleConnecter connectPeripheral:peripheral options:options];
}

/**
 *  方法说明: 向输出流中写入数据（只适用于蓝牙）
 *  @param data 需要写入的数据
 *  @param progress 写入数据进度
 *  @param callBack 读取输入流中的数据
 */
-(void)write:(NSData *_Nullable)data progress:(void(^_Nullable)(NSUInteger total,NSUInteger progress))progress receCallBack:(void (^_Nullable)(NSData *_Nullable receCallData))callBack {
    [self.bleConnecter write:data progress:progress receCallBack:callBack];
}

/**
 *  方法说明：向输出流中写入数据
 *  @param callBack 读取数据接口
 */
-(void)write:(NSData *)data receCallBack:(void (^)(NSData * receCallData))callBack {
#ifdef DEBUG
    NSLog(@"[ConnecterManager] write:receCallBack:");
#endif
    self.bleConnecter.writeProgress = nil;
    [self.connecter write:data receCallBack:callBack];
}

/**
 *  方法说明：向输出流中写入数据
 *  @param data 需要写入的数据
 */
-(void)write:(NSData *)data {
#ifdef DEBUG
    NSLog(@"[ConnecterManager] write:");
#endif
    self.bleConnecter.writeProgress = nil;
    [self.connecter write:data];
}

/**
 *  方法说明：关闭连接
 */
-(void)close {
    if (self.connecter) {
        [self.connecter close];
    }
    switch (self.currentConnMethod) {
        case BLUETOOTH:
            self.bleConnecter = nil;
            break;
        case ETHERNET:
            self.ethernetConnecter = nil;
            break;
    }
}

/**
 选择设备

 @param peripheral 设备
 @param options 设置
 @param timeout 超时时间
 */
-(void)selectPeripheral:(CBPeripheral *)peripheral withOptions:(nullable NSDictionary<NSString *,id> *)options timeOut:(NSUInteger)timeout{
    self.peripheral = peripheral;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral options:options timeout:timeout connectBlock:^(ConnectState state) {
        weakSelf.connectState = state;
    }];
}

/**
 注册链接状态监听

 @param observer 监听者
 @param selector 响应方法
 */
-(void)addConnectStateNotificationObserver:(id)observer selector:(nonnull SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:PrinterConnectStateChangeNotificationName object:self];
}

/**
 移除链接状态监听

 @param observer 监听者3
 */
-(void)removeConnectStateNotificationObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:PrinterConnectStateChangeNotificationName object:self];
}

#pragma mark - setters and getters
-(NSMutableDictionary *)scanResultDict{
    if (!_scanResultDict) {
        _scanResultDict = [NSMutableDictionary dictionary];
    }
    return _scanResultDict;
}
-(void)setConnectState:(ConnectState)connectState{
    _connectState = connectState;
    [[NSNotificationCenter defaultCenter] postNotificationName:PrinterConnectStateChangeNotificationName object:self userInfo:@{PrinterConnectStateKey: @(connectState)}];
}
-(BOOL)hasConnectPrinter{
    if (self.connectState == CONNECT_STATE_CONNECTED) {
        return YES;
    }
    return NO;
}
-(NSString *)getPeripheralName{
    if (self.peripheral != nil) {
        return self.peripheral.name;
    }
    return nil;
}
@end
