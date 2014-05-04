//
//  DDGryoModeViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSingletonBluetooth.h"
#import "Server.h"
#import "DDManualImageView.h"
#import "DDSingletonArray.h"

#define IMAGE_WIDTH_OFFSET 8
#define IMAGE_HEIGHT_OFFSET 300
#define IMAGE_HEIGHT_BETWEEN_OFFSET 100

@class DDGyroModeViewController;

@protocol DDGyroModeDelegate <NSObject>

- (void)didCancelGyroMode:(DDGyroModeViewController *)controller;

@end

@interface DDGyroModeViewController : UIViewController<DDSingletonBluetoothDelegate, DDSingletonGyroBluetoothDelegate>

@property (nonatomic, weak) id <DDGyroModeDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *serverStateLabel;

@property (nonatomic, assign) int state;

@property (nonatomic) char xGyro;
@property (nonatomic) char yGyro;
@property (nonatomic) char zGyro;

@property (nonatomic) CGFloat screenWidth;

@property NSMutableArray *previewArray;

@property (strong, nonatomic) NSTimer *gyroTimer;
@property (strong, nonatomic) NSTimer *updateServerTimer;

@end
