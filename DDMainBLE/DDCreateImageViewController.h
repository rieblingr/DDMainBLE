//
//  DDCreateImageViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/24/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCreateImageView.h"
#import "DDSingletonArray.h"

@class DDCreateImageViewController;

@protocol DDCreateImageViewControllerDelegate <NSObject>

- (void) ddCreateImageVCDidCancel: (DDCreateImageViewController *)controller;

@end

@interface DDCreateImageViewController : UIViewController<DDCreateImageViewDelegate>

@property (nonatomic, strong) DDCreateImageView *createView;

@property (nonatomic, strong) id<DDCreateImageViewControllerDelegate> delegate;

// Values passed from Segue
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int imageSelected;

- (IBAction)cancel:(id)sender;


@end
