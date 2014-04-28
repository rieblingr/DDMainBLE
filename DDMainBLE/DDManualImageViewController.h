//
//  DDManualImageViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDManualImageViewController;

@protocol DDManualImageDelegate <NSObject>

- (void)didCancelManualMode:(DDManualImageViewController *)controller;

@end

@interface DDManualImageViewController : UIViewController

@property (nonatomic, weak) id <DDManualImageDelegate> delegate;

-(IBAction)cancel:(id)sender;

@end
