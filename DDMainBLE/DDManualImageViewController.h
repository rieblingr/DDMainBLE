//
//  DDManualImageViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSingletonArray.h"
#import "Server.h"
#import "DDManualImageView.h"
#import "DDSingletonArray.h"

@class DDManualImageViewController;

@protocol DDManualImageDelegate <NSObject>

- (void)didCancelManualMode:(DDManualImageViewController *)controller;

@end

@interface DDManualImageViewController : UIViewController<DDManualImageViewDelegate>

@property (nonatomic, strong) IBOutlet DDManualImageView *preview;
@property (strong, nonatomic) IBOutlet UILabel *sendingDataLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *sendingDataIndicator;

@property (nonatomic, weak) id <DDManualImageDelegate> delegate;
@property (nonatomic, assign) int state;
@property (strong, nonatomic) IBOutlet UILabel *serverStateLabel;

-(IBAction)cancel:(id)sender;

@end
