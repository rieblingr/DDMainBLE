//
//  DDGryoModeViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@class DDGyroModeViewController;

@protocol DDGyroModeDelegate <NSObject>

- (void)didCancelGyroMode:(DDGyroModeViewController *)controller;

@end

@interface DDGyroModeViewController : UIViewController

@property (nonatomic, weak) id <DDGyroModeDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *serverStateLabel;

@property (nonatomic, assign) int state;

@end
