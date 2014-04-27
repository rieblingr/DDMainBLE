//
//  DDCreateImageSetViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCreateImageViewController.h"

@class DDCreateImageSetViewController;

@protocol DDCreateImageSetViewControllerDelegate <NSObject>
- (void)getImageSet:(NSArray *)images;

@end

@interface DDCreateImageSetViewController : UIViewController<DDCreateImageViewControllerDelegate>

@property (nonatomic, weak) id <DDCreateImageSetViewControllerDelegate> delegate;

@end
