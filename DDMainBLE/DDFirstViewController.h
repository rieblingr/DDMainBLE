//
//  DDFirstViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBLEViewController.h"
#import "DDExecuteDiceViewController.h"
#import "Server.h"

@interface DDFirstViewController : UIViewController<DDBLEViewControllerDelegate, DDExecuteDiceViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSData *serverState;

@property (nonatomic, strong) IBOutlet UIButton *initializeBLEBtn;
@property (nonatomic, strong) IBOutlet UILabel* connectionStatus;

@property (strong, nonatomic) IBOutlet UILabel *deviceConnection;
@property (strong, nonatomic) IBOutlet UILabel *serverStatus;


// Instance Methods

@end
