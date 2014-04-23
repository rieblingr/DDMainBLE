//
//  DDBLEViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/22/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGBluetooth.h"
@import QuartzCore;
@import CoreBluetooth;

@class DDBLEViewController;

@protocol DDBLEViewControllerDelegate <NSObject>
- (void) ddBLEViewControllerDidCancel:(DDBLEViewController *)controller;
- (void) ddBLEViewControllerDidSave:(DDBLEViewController *)controller;
@end


@interface DDBLEViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate>
// Services on DD hardware
#define DD_DEVICE_INFO_SERVICE_UUID @"1800"
#define DD_DISPLAY_SERVICE_UUID @"cd45"
#define DD_GYRO_SERVICE_UUID @"7cbd"

// Characteristics - NEED TO CHANGE
#define DD_NAME_CHARACTERISTIC_UUID @"2a00"
#define DD_APPEARANCE_CHARACTERISTIC_UUID @"2a01"

#define DD_DISPLAY_DATA_CHARACTERISTIC_UUID @"5c87"
#define DD_DISPLAY_TARGET_CHARACTERISTIC_UUID @"1daa"
#define DD_DISPLAY_BUSY_CHARACTERISTIC_UUID @"3b20"

#define DD_GYRO_DATA_CHARACTERISTIC_UUID @"49d2"

@property (nonatomic, strong) LGCentralManager *lgCentralManager;
@property (nonatomic, strong) LGPeripheral *lgPeripheral;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *cbPeripheral;

// Properties for your Object controls
@property (nonatomic, strong) IBOutlet UILabel *connectionStatus;
@property (nonatomic, strong) IBOutlet UIButton *connectBLEBtn;
@property (nonatomic, strong) IBOutlet UITextView *deviceInfo;

// Properties to hold data characteristics for the peripheral device
@property (nonatomic, strong) NSString *connected;

@property (nonatomic, strong) UILabel *displayTarget;
@property (nonatomic, strong) NSString *gyroDataFound;
@property (nonatomic, strong) NSString *displayDataFound;
@property (nonatomic, strong) NSString *dynamidiceDeviceData;
@property (assign) uint16_t displayBusy;

// Data from peripherals
@property (nonatomic, strong) NSData *displayData;
@property (nonatomic, strong) NSData *gyroData;

@property (nonatomic, weak) id <DDBLEViewControllerDelegate> delegate;

// UI Methods
- (IBAction)connectPressed:(UIButton *)sender;
- (void)testPeripheral:(LGPeripheral *)peripheral;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
