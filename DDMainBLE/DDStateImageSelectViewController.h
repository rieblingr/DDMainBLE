//
//  DDStateImageViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCreateImageViewController.h"

@class DDStateImageSelectViewController;

@protocol DDStateImageSelectDelegate <NSObject>

- (void) didCreateImageArray:(NSData *)data;
- (void) didCancelStateImageSelect: (DDStateImageSelectViewController *)controller;

@end

@interface DDStateImageSelectViewController : UIViewController<DDCreateImageViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *imageSetLabel;

@property (nonatomic, weak) id <DDStateImageSelectDelegate> delegate;
@property (nonatomic, assign) int state;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
