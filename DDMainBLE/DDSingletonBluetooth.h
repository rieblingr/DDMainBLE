//
//  DDSingletonBluetooth.h
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/28/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSingletonArray.h"

@import QuartzCore;
@import CoreBluetooth;

@protocol DDSingletonGyroBluetoothDelegate <NSObject>
-(NSMutableArray*) gyroDataReceived;
@end

@protocol DDSingletonBluetoothDelegate <NSObject>

-(void) finishedSending;

@end

@interface DDSingletonBluetooth : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

//bluetooth
@property (strong, nonatomic) NSMutableArray *table;
@property (strong, nonatomic) NSMutableArray *data;
@property char dispBitMask;

//Display Delegate
@property (weak, nonatomic) id<DDSingletonBluetoothDelegate> delegate;

//Gryo Delegate
@property (weak, nonatomic) id<DDSingletonGyroBluetoothDelegate> gyroDelegate;

// Services on DD hardware
#define DD_DEVICE_INFO_SERVICE_UUID @"1800"
#define DISPLAY_DATA_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af00"
#define DISPLAY_INFO_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af30"
#define GYRO_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af40"

// Characteristics
#define DD_NAME_CHARACTERISTIC_UUID @"2a00"
#define DD_APPEARANCE_CHARACTERISTIC_UUID @"2a01"

//First service
#define DISPLAY_DATA_BASE_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af"

//Second Service
#define DISPLAY_INFO_TARGET_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af31"
#define DISPLAY_INFO_BUSY_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af32"

//Third Service
#define GYRO_X_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af41"
#define GYRO_Y_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af42"
#define GYRO_Z_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af43"

//Bluetooth Objects
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBService *dispDataService;
@property (nonatomic, strong) CBService *dispInfoService;
@property (nonatomic, strong) CBService *gyroService;
@property CBCharacteristicWriteType writeType;
@property (nonatomic, strong) NSArray *ddServices;

@property (nonatomic, assign) char *xData;
@property (nonatomic, assign) char *yData;
@property (nonatomic, assign) char *zData;

//functions
- (void)startTransferWithArray:(NSMutableArray *)array withBitmask:(char)dispBitmask;

- (void) disconnect;

-(void) getGyroData;

//singleton functions
+(id) singleton;

@end
