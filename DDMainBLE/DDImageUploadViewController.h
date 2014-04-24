//
//  DDImageUploadViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/22/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDImageUploadViewController;

@protocol DDImageUploadViewControllerDelegate <NSObject>

- (void) ddImageUploadVCDidCancel: (DDImageUploadViewController *)controller;

@end

@interface DDImageUploadViewController : UITableViewController

@property (nonatomic, weak) id <DDImageUploadViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;

@end
