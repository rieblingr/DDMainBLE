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

@protocol DDSingletonBluetoothDelegate <NSObject>

-(void) finishedSending;

@end

@interface DDSingletonBluetooth : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

//bluetooth
@property (strong, nonatomic) NSMutableArray *table;
@property (strong, nonatomic) NSMutableArray *data;
@property char dispBitMask;

//delegate
@property (weak, nonatomic) id<DDSingletonBluetoothDelegate> delegate;

// Services on DD hardware
#define DD_DEVICE_INFO_SERVICE_UUID @"1800"
#define DISPLAY_DATA_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af00"
#define DISPLAY_INFO_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af30"
#define GYRO_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af40"

// Characteristics - NEED TO CHANGE
#define DD_NAME_CHARACTERISTIC_UUID @"2a00"
#define DD_APPEARANCE_CHARACTERISTIC_UUID @"2a01"

#define DISPLAY_DATA_BASE_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af"
#define DISPLAY_INFO_TARGET_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af31"
#define DISPLAY_INFO_BUSY_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af32"
#define GYRO_DATA_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af11"

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBService *dispDataService;
@property (nonatomic, strong) CBService *dispInfoService;
@property (nonatomic, strong) CBService *gyroService;

@property CBCharacteristicWriteType writeType;
@property (nonatomic, strong) NSArray *ddServices;

//functions
- (void)startTransferWithArray:(NSMutableArray *)array withBitmask:(char)dispBitmask;

- (void) disconnect;

//singleton functions
+(id) singleton;

@end
