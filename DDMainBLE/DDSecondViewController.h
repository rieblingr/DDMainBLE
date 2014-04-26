//
//  DDSecondViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDImageUploadViewController.h"
#import "DDCreateImageViewController.h"
#import "DDAppDelegate.h"

@class DDSecondViewController;

@protocol DDSecondViewControllerDelegate <NSObject>
- (void) receiveImageArray:(NSArray *)array;
- (void) receiveImageSetArrays:(NSArray *)sets;
@end

@interface DDSecondViewController : UIViewController <DDImageUploadViewControllerDelegate, DDCreateImageViewControllerDelegate>


@property (nonatomic, strong) IBOutlet UIButton *configureImages;
@property (nonatomic, strong) IBOutlet UIButton *viewImageSets;
@property (strong, nonatomic) IBOutlet UIButton *createImage;

@property (strong, nonatomic) IBOutlet UIImageView *createdImage;

@property (nonatomic, weak) id <DDSecondViewControllerDelegate> delegate;

@end
