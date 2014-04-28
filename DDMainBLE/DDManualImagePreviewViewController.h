//
//  DDManualImagePreviewViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSingletonArray.h"
#import "DDManualImageView.h"

@class DDManualImagePreviewViewController;

@protocol DDManualImagePreviewDelegate <NSObject>

-(void)didCancel:(DDManualImagePreviewViewController *)controller;

@end

@interface DDManualImagePreviewViewController : UIViewController <DDManualImageViewDelegate>

@property (nonatomic, assign) int state;
@property (nonatomic, assign) int imageSelected;

@property (nonatomic, weak) id <DDManualImagePreviewDelegate> delegate;
@end
