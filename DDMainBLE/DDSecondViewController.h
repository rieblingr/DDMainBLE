//
//  DDSecondViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDStateSelectViewController.h"
#import "DDAppDelegate.h"

@class DDSecondViewController;

@protocol DDSecondViewControllerDelegate <NSObject>

@end

@interface DDSecondViewController : UIViewController <DDStateSelectDelegate, UIAlertViewDelegate>

@property CGFloat BUTTON_SIZE;
@property (nonatomic, assign) int state;
@property (strong, nonatomic) NSMutableArray *defaultImage;

@property (nonatomic, strong) IBOutlet UIButton *configureImages;
@property (strong, nonatomic) IBOutlet UILabel *serverStateLabel;
@property (strong, nonatomic) UIAlertView *statusAlert;

@property (nonatomic, weak) id <DDSecondViewControllerDelegate> delegate;

- (IBAction)setDefaultImages:(id)sender;

@end
