//
//  DDSecondViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDStateSelectViewController.h"
#import "DDCreateImageSetViewController.h"
#import "DDAppDelegate.h"

@class DDSecondViewController;

@protocol DDSecondViewControllerDelegate <NSObject>

@end

@interface DDSecondViewController : UIViewController <DDStateSelectDelegate>


@property (nonatomic, strong) IBOutlet UIButton *configureImages;
@property (strong, nonatomic) IBOutlet UILabel *serverStateLabel;




@property (nonatomic, weak) id <DDSecondViewControllerDelegate> delegate;

@end
