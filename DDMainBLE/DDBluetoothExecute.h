//
//  DDBluetoothExecute.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <Foundation/Foundation.h>
@import QuartzCore;
@import CoreBluetooth;

@protocol DDBluetoothExecuteDelegate <NSObject>

- (void)finishedTransfer;

@end

@interface DDBluetoothExecute : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) id <DDBluetoothExecuteDelegate> delegate;

//array data to send
@property (weak, nonatomic) NSMutableArray *data;
@property int dispBitMask;

// Services on DD hardware
#define DD_DEVICE_INFO_SERVICE_UUID @"1800"
#define DISPLAY_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af00"
#define GYRO_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af10"

// Characteristics - NEED TO CHANGE
#define DD_NAME_CHARACTERISTIC_UUID @"2a00"
#define DD_APPEARANCE_CHARACTERISTIC_UUID @"2a01"

#define DISPLAY_DATA_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af01"
#define DISPLAY_TARGET_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af02"
#define DISPLAY_INDEX_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af03"
#define GYRO_DATA_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af11"

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBService *displayService;
@property (nonatomic, strong) CBService *gyroService;

@property CBCharacteristicWriteType writeType;
@property (nonatomic, strong) NSArray *ddServices;

//functions
- (void) startTransferWithArray:(NSMutableArray*)array withBitmask:(int)dispBitmask;

@end
