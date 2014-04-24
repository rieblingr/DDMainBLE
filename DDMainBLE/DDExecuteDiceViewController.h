//
//  DDExecuteDiceViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/24/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDExecuteDiceViewController;

@protocol DDExecuteDiceViewControllerDelegate <NSObject>

- (void) ddExecuteDiceVCDidStop: (DDExecuteDiceViewController *)controller;
@end


@interface DDExecuteDiceViewController : UIViewController

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

@property (nonatomic, weak) id <DDExecuteDiceViewControllerDelegate> delegate;

-(IBAction)stop:(id)sender;

@end
