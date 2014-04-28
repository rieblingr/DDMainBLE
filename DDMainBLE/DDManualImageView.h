//
//  DDManualImageView.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDButtonCreateImage.h"
#import "DDSingletonArray.h"
@import QuartzCore;
@import CoreBluetooth;

#define IMAGE_WIDTH 32
#define IMAGE_HEIGHT 32
#define BUTTON_HEIGHT_OFFSET 0
#define CONTROL_WIDTH_OFFSET 15
#define CONTROL_HEIGHT_DIFF_OFFSET 5
#define CONTROL_WIDTH 50
#define CONTROL_HEIGHT 20

@protocol DDManualImageViewDelegate <NSObject>

-(void) sendPicture;

@end

@interface DDManualImageView : UIView < CBCentralManagerDelegate, CBPeripheralDelegate>

- (id)initWithFrame:(CGRect)frame withArray:(NSMutableArray*) buttons;

@property int state;
@property int imageSelected;

//delegate object
@property (weak, nonatomic) id<DDManualImageViewDelegate> delegate;

//now have the send button
@property (strong, nonatomic) UIButton *sendButton;

//table
@property (strong, nonatomic) NSMutableArray *table;

@property CGFloat BUTTON_SIZE;

//bluetooth
@property (weak, nonatomic) NSMutableArray *data;
@property int dispBitMask;

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
- (void) startTransferWithArray:(NSMutableArray*)array withBitmask:(int)dispBitmask;



@end
