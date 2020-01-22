//
//  PrinterConneterManager.m
//  Pet
//
//  Created by mac on 2020/1/21.
//  Copyright © 2020年 mac. All rights reserved.
//

#import "PrinterConneterManager.h"



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
 * 初始化连接器
 * @param connectMethod 连接方法
 */
-(void)initConnecter:(ConnectMethod)connectMethod {
    switch (connectMethod) {
        case BLUETOOTH:
            _bleConnecter = [BLEConnecter new];
            _connecter = _bleConnecter;
            break;
        case ETHERNET:
            _ethernetConnecter = [EthernetConnecter new];
            _connecter = _ethernetConnecter;
            break;
        default:
            break;
    }
}

#pragma mark - ethernet

/**
 *  方法说明：连接指定ip和端口号的网络设备
 *  @param ip 设备的ip地址
 *  @param port 设备端口号
 *  @param connectBlock 连接状态
 *  @param callback 读取数据接口
 */
-(void)connectIP:(NSString *)ip port:(int)port connectBlock:(void (^)(ConnectState state))connectBlock callback:(void (^)(NSData *))callback {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (weakSelf.ethernetConnecter == nil) {
            weakSelf.currentConnMethod = ETHERNET;
            [weakSelf initConnecter:weakSelf.currentConnMethod];
        }
        [weakSelf.ethernetConnecter connectIP:ip port:port connectState:connectBlock callback:callback];
    });
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
    [_bleConnecter scanForPeripheralsWithServices:serviceUUIDs options:options discover:^(CBPeripheral * _Nullable peripheral, NSDictionary<NSString *,id> * _Nullable advertisementData, NSNumber * _Nullable RSSI) {
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
    [_bleConnecter scanForPeripheralsWithServices:serviceUUIDs options:options discover:discover];
}

/**
 *  方法说明：更新蓝牙状态
 *  @param state 蓝牙状态
 */
-(void)didUpdateState:(void(^)(NSInteger state))state {
    if (_bleConnecter == nil) {
        _currentConnMethod = BLUETOOTH;
        [self initConnecter:_currentConnMethod];
    }
    [_bleConnecter didUpdateState:state];
}

/**
 *  方法说明：停止扫描
 */
-(void)stopScan {
    [_bleConnecter stopScan];
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
    [_bleConnecter connectPeripheral:peripheral options:options timeout:timeout connectBlack:connectBlock];
}

/**
 *  方法说明：连接外设
 *  @param peripheral 需连接的外设
 *  @param options 其它可选操作
 */
-(void)connectPeripheral:(CBPeripheral * _Nullable)peripheral options:(nullable NSDictionary<NSString *,id> *)options {
    self.peripheral = peripheral;
    [_bleConnecter connectPeripheral:peripheral options:options];
}

/**
 *  方法说明: 向输出流中写入数据（只适用于蓝牙）
 *  @param data 需要写入的数据
 *  @param progress 写入数据进度
 *  @param callBack 读取输入流中的数据
 */
-(void)write:(NSData *_Nullable)data progress:(void(^_Nullable)(NSUInteger total,NSUInteger progress))progress receCallBack:(void (^_Nullable)(NSData *_Nullable))callBack {
    [_bleConnecter write:data progress:progress receCallBack:callBack];
}

/**
 *  方法说明：向输出流中写入数据
 *  @param callBack 读取数据接口
 */
-(void)write:(NSData *)data receCallBack:(void (^)(NSData *))callBack {
#ifdef DEBUG
    NSLog(@"[ConnecterManager] write:receCallBack:");
#endif
    _bleConnecter.writeProgress = nil;
    [_connecter write:data receCallBack:callBack];
}

/**
 *  方法说明：向输出流中写入数据
 *  @param data 需要写入的数据
 */
-(void)write:(NSData *)data {
#ifdef DEBUG
    NSLog(@"[ConnecterManager] write:");
#endif
    _bleConnecter.writeProgress = nil;
    [_connecter write:data];
}

/**
 *  方法说明：关闭连接
 */
-(void)close {
    if (_connecter) {
        [_connecter close];
    }
    switch (_currentConnMethod) {
        case BLUETOOTH:
            _bleConnecter = nil;
            break;
        case ETHERNET:
            _ethernetConnecter = nil;
            break;
    }
}

-(void)selectPeripheral:(CBPeripheral *)peripheral withOptions:(nullable NSDictionary<NSString *,id> *)options timeOut:(NSUInteger)timeout{
    self.peripheral = peripheral;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral options:options timeout:timeout connectBlock:^(ConnectState state) {
        weakSelf.connectState = state;
    }];
}

-(void)addConnectStateNotificationObserver:(id)observer selector:(nonnull SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:PrinterConnectStateChangeNotificationName object:self];
}

-(void)removeConnectStateNotificationObserver:(id)observer{
    
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
@end
