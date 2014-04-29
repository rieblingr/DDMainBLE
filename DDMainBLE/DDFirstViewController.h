//
//  DDFirstViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDManualImageViewController.h"
#import "DDGyroModeViewController.h"
#import "Server.h"

@interface DDFirstViewController : UIViewController<DDManualImageDelegate, DDGyroModeDelegate>


@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSDictionary *serverStateData;


@property (nonatomic, strong) IBOutlet UILabel* connectionStatus;

@property (strong, nonatomic) IBOutlet UILabel *deviceConnection;
@property (strong, nonatomic) IBOutlet UILabel *serverStatus;
@property (strong, nonatomic) IBOutlet UIButton *initiateExecutionBtn;


// Instance Methods
-(void) updateServerLabel;
@end
