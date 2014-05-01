//
//  DDStateImageViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCreateImageViewController.h"
#import "DDSingletonArray.h"
#import "DDButtonCreateImage.h"

#define IMAGE_WIDTH 32
#define IMAGE_HEIGHT 28

@class DDStateImageSelectViewController;

@protocol DDStateImageSelectDelegate <NSObject>

- (void) didCancelStateImageSelect: (DDStateImageSelectViewController *)controller;

@end

@interface DDStateImageSelectViewController : UIViewController<DDCreateImageViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *imageSetLabel;

@property (strong, nonatomic) NSMutableArray *defaultImage;

@property (nonatomic, weak) id <DDStateImageSelectDelegate> delegate;
@property (nonatomic, assign) int state;


- (IBAction)setDefaultImages:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
