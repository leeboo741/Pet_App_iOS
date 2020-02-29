//
//  PrinterConneterManager.h
//  Pet
//
//  Created by mac on 2020/1/21.
//  Copyright © 2020年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEConnecter.h"
#import "EthernetConnecter.h"
#import "Connecter.h"
#import "OrderEntity.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *  @enum ConnectMethod
 *  @discussion 连接方式
 *  @constant BLUETOOTH 蓝牙连接
 *  @constant ETHERNET 网口连接（wifi连接）
 */
typedef enum : NSUInteger{
    BLUETOOTH,
    ETHERNET
}ConnectMethod;

typedef void(^ConnectStateBlock)(ConnectState state);

@interface PrinterConneterManager : NSObject

SingleInterface(PrinterConneterManager)

/**
 点击打印 开始打印

 @param orderEntity 需要打印的单据
 */
-(void)startPrinter:(OrderEntity * )orderEntity;

#pragma mark - 蓝牙相关
#pragma mark -

/**
 *  方法说明：更新蓝牙状态
 *  @param state 蓝牙状态
 */
-(void)didUpdateState:(void(^)(NSInteger state))state;

/**
 检查蓝牙状态
 
 @param ableUseCallback 蓝牙可用回调
 */
-(void)checkBluetoothState:(void(^)(BOOL ableUse))ableUseCallback;

#pragma mark - 外设相关 扫描 获取 链接
#pragma mark -

/**
 *  方法说明：扫描外设
 *  @param serviceUUIDs 需要发现外设的UUID，设置为nil则发现周围所有外设
 *  @param options  其它可选操作
 *  @param discover 发现的设备
 */
-(void)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs options:(nullable NSDictionary<NSString *, id> *)options discover:(void(^_Nullable)(CBPeripheral *_Nullable peripheral,NSDictionary<NSString *, id> *_Nullable advertisementData,NSNumber *_Nullable RSSI))discover;

/**
 *  方法说明：停止扫描
 */
-(void)stopScan;

/**
 *  方法说明：连接外设
 *  @param peripheral 需连接的外设
 *  @param options 其它可选操作
 *  @param timeout 连接时间
 *  @param connectBlock 连接状态
 */
-(void)connectPeripheral:(CBPeripheral *)peripheral options:(nullable NSDictionary<NSString *,id> *)options timeout:(NSUInteger)timeout connectBlock:(void(^_Nullable)(ConnectState state)) connectBlock;

/**
 *  方法说明：连接外设
 *  @param peripheral 需连接的外设
 *  @param options 其它可选操作
 */
-(void)connectPeripheral:(CBPeripheral * _Nullable)peripheral options:(nullable NSDictionary<NSString *,id> *)options;

/**
 *  方法说明：关闭连接
 */
-(void)close;

/**
 是否链接到打印设备

 @return 是否链接到打印设备 yes 链接 no 未连接
 */
-(BOOL)hasConnectPrinter;

/**
 获取当前链接设备名称

 @return 设备名称
 */
-(NSString *)getPeripheralName;

/**
 *  获取外设设备
 *  @param serviceUUIDs 需要发现外设的UUID，设置为nil则发现周围所有外设
 *  @param options  其它可选操作
 *  @param resultCallback 结果回调
 */
-(void)getPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs options:(nullable NSDictionary<NSString *, id> *)options resultCallback:(void(^_Nullable)(NSDictionary* resultDict))resultCallback;

#pragma mark - 监听
#pragma mark -

/**
 注册链接状态监听
 
 @param observer 监听者
 @param selector 响应方法
 */
-(void)addConnectStateNotificationObserver:(id)observer selector:(nonnull SEL)selector;

/**
 移除链接状态监听
 
 @param observer 监听者
 */
-(void)removeConnectStateNotificationObserver:(id)observer;

#pragma mark - 数据写入
#pragma mark -

/**
 *  方法说明: 向输出流中写入数据（只适用于蓝牙）
 *  @param data 需要写入的数据
 *  @param progress 写入数据进度
 *  @param callBack 读取输入流中的数据
 */
-(void)write:(NSData *_Nullable)data progress:(void(^_Nullable)(NSUInteger total,NSUInteger progress))progress receCallBack:(void (^_Nullable)(NSData *_Nullable receCallData))callBack;

/**
 *  方法说明：向输出流中写入数据
 *  @param callBack 读取数据接口
 */
-(void)write:(NSData *)data receCallBack:(void (^)(NSData * receCallData))callBack;

/**
 *  方法说明：向输出流中写入数据
 *  @param data 需要写入的数据
 */
-(void)write:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
