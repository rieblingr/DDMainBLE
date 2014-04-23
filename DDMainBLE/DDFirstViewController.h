//
//  DDFirstViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBLEViewController.h"

@interface DDFirstViewController : UIViewController<DDBLEViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *services;

@property (nonatomic, strong) IBOutlet UIButton *initializeBLEBtn;


@end
