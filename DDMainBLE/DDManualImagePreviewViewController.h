//
//  DDManualImagePreviewViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDManualImagePreviewViewController;

@protocol DDManualImagePreviewDelegate <NSObject>

-(void)didCancel:(DDManualImagePreviewViewController *)controller;

@end

@interface DDManualImagePreviewViewController : UIViewController

@property (nonatomic, assign) int state;
@property (nonatomic, assign) int imageSelected;

@property (nonatomic, weak) id <DDManualImagePreviewDelegate> delegate;
@end
