//
//  DDExecuteDiceViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/24/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuartzCore;
@import CoreBluetooth;

@class DDExecuteDiceViewController;

@protocol DDExecuteDiceViewControllerDelegate <NSObject>

- (void) ddExecuteDiceVCDidStop: (DDExecuteDiceViewController *)controller;
@end

// Constants
extern const uint8_t DISPLAY_IS_BUSY;

@interface DDExecuteDiceViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate>

// Services on DD hardware
#define DD_DEVICE_INFO_SERVICE_UUID @"1800"
#define DD_DISPLAY_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af00"
#define DD_GYRO_SERVICE_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af10"

// Characteristics - NEED TO CHANGE
#define DD_NAME_CHARACTERISTIC_UUID @"2a00"
#define DD_APPEARANCE_CHARACTERISTIC_UUID @"2a01"

#define DD_DISPLAY_DATA_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af01"
#define DD_DISPLAY_TARGET_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af02"
#define DD_DISPLAY_BUSY_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af03"

#define DD_GYRO_DATA_CHARACTERISTIC_UUID @"0d605bad-e1db-d7cb-b79f-46b3ec27af11"

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;

// Bluetooth Service and Characteristic Arrays
@property (strong, nonatomic) NSArray *ddServices;
@property (strong, nonatomic) NSArray *busyCharArray;
@property (strong, nonatomic) NSArray *displayWriteCharsArray;

// Server State and Time Values
@property (strong, nonatomic) NSNumber *state;
@property (strong, nonatomic) NSString *serverTimeStamp;
@property (strong, nonatomic) NSString *deviceTimeStamp;

// UI Elements
@property (strong, nonatomic) IBOutlet UILabel *initializeBLELabel;
@property (strong, nonatomic) IBOutlet UIProgressView *connectingBLEProgress;
@property (strong, nonatomic) IBOutlet UILabel *initializeServerStateLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *connectingServerProgress;
@property (strong, nonatomic) IBOutlet UILabel *initializeImageSetLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *loadingImagesProgress;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;
@property (strong, nonatomic) IBOutlet UIImageView *image5;
@property (strong, nonatomic) IBOutlet UIImageView *image6;
@property (strong, nonatomic) IBOutlet UILabel *nowExecutingLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *executingIndicator;

// Grayscale Images
@property (strong, nonatomic) UIImage *imageGray1;
@property (strong, nonatomic) UIImage *imageGray2;
@property (strong, nonatomic) UIImage *imageGray3;
@property (strong, nonatomic) UIImage *imageGray4;
@property (strong, nonatomic) UIImage *imageGray5;
@property (strong, nonatomic) UIImage *imageGray6;
// Converted grayscale ByteArray Images
@property (assign, nonatomic) uintmax_t byteArrayImage1;
@property (assign, nonatomic) uintmax_t byteArrayImage2;
@property (assign, nonatomic) uintmax_t byteArrayImage3;
@property (assign, nonatomic) uintmax_t byteArrayImage4;
@property (assign, nonatomic) uintmax_t byteArrayImage5;
@property (assign, nonatomic) uintmax_t byteArrayImage6;

// Properties to hold data characteristics for the peripheral device
@property (nonatomic, strong) NSString *connected;
@property (nonatomic, strong) NSString *displayTargetFound;
@property (nonatomic, strong) NSString *gyroDataFound;
@property (nonatomic, strong) NSString *displayDataFound;
@property (nonatomic, strong) NSString *displayBusyFound;
@property (nonatomic, strong) NSString *dynamidiceDeviceData;
@property (nonatomic, assign) uint8_t displayBusyValueRead;
@property (nonatomic, assign) uint8_t displayBusyValueToWrite;
@property (nonatomic, assign) uint8_t displayTargetValueToWrite;
@property (nonatomic, assign) uintmax_t displayDataValueToWrite;
@property (nonatomic, assign) uint8_t gyroDataValueRead;
@property (nonatomic, assign) int count;

// Timer for setting server state
@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, weak) id <DDExecuteDiceViewControllerDelegate> delegate;

-(IBAction)stop:(id)sender;

@end
