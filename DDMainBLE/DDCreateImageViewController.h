//
//  DDCreateImageViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/24/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCreateImageView.h"

@class DDCreateImageViewController;

@protocol DDCreateImageViewControllerDelegate <NSObject>

- (void) ddCreateImageVCDidCancel: (DDCreateImageViewController *)controller;

- (void) ddCreateImageVC : (NSData *) data;

@end

@interface DDCreateImageViewController : UIViewController <DDCreateImageViewDelegate>

@property (nonatomic, weak) id <DDCreateImageViewControllerDelegate> delegate;

@property (nonatomic, strong) DDCreateImageView *createView;

- (IBAction)cancel:(id)sender;


@end
