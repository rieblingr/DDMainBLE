//
//  DDBLEViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/22/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuartzCore;
@import CoreBluetooth;

@class DDBLEViewController;

@protocol DDBLEViewControllerDelegate <NSObject>
- (void) ddBLEViewControllerDidCancel:(DDBLEViewController *)controller;
- (void) ddBLEViewControllerDidConnectSuccessful:(DDBLEViewController *)controller;
@end


@interface DDBLEViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate, UIAlertViewDelegate>
// Services on DD hardware
#define DD_DEVICE_INFO_SERVICE_UUID @"1800"
#define DD_DISPLAY_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af00"
#define DD_GYRO_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af10"

// Characteristics
#define DD_NAME_CHARACTERISTIC_UUID @"2a00"
#define DD_APPEARANCE_CHARACTERISTIC_UUID @"2a01"

#define DD_DISPLAY_DATA_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af01"
#define DD_DISPLAY_TARGET_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af02"
#define DD_DISPLAY_BUSY_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af03"

#define DD_GYRO_DATA_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af11"

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *cbPeripheral;

// Properties for your Object controls
@property (nonatomic, strong) IBOutlet UILabel *connectionStatus;
@property (strong, nonatomic) IBOutlet UILabel *deviceName;

@property (nonatomic, strong) IBOutlet UIButton *connectBLEBtn;
@property (nonatomic, strong) IBOutlet UITextView *deviceInfo;
@property (nonatomic, strong) IBOutlet UIButton *connectSuccessBtn;

// Properties to hold data characteristics for the peripheral device
@property (nonatomic, strong) NSString *connected;
@property (nonatomic, strong) NSString *displayTargetFound;
@property (nonatomic, strong) NSString *gyroDataFound;
@property (nonatomic, strong) NSString *displayDataFound;
@property (nonatomic, strong) NSString *displayBusyFound;
@property (nonatomic, strong) NSString *dynamidiceDeviceData;
@property (nonatomic, assign) uint8_t displayBusyValue;
@property (nonatomic, assign) uint16_t displayDataValue;
@property (nonatomic, assign) uint16_t displayTargetValue;

@property (assign) BOOL errorFound;


// Data from peripherals
@property (nonatomic, strong) NSData *displayData;
@property (nonatomic, strong) NSData *gyroData;

@property (nonatomic, weak) id <DDBLEViewControllerDelegate> delegate;

// Instance methods
- (void) helpGetGyroData:(CBCharacteristic *)characteristic;
- (void) helpGetDisplayBusy:(CBCharacteristic *)characteristic;
- (void) helpGetDeviceInfo:(CBCharacteristic *)characteristic;

// UI Methods
- (IBAction)connectPressed:(UIButton *)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
