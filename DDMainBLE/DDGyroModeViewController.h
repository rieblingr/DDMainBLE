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

@class DDGyroModeViewController;

@protocol DDGyroModeDelegate <NSObject>

- (void)didCancelGyroMode:(DDGyroModeViewController *)controller;

@end

@interface DDGyroModeViewController : UIViewController<DDSingletonBluetoothDelegate, DDSingletonGyroBluetoothDelegate>

@property (nonatomic, weak) id <DDGyroModeDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *serverStateLabel;

@property (nonatomic, assign) int state;

@property (nonatomic) unsigned char* xGyro;
@property (nonatomic) unsigned char* yGyro;
@property (nonatomic) unsigned char* zGyro;

@end
