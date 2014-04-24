//
//  DDSecondViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDImageUploadViewController.h"

@interface DDSecondViewController : UIViewController <DDImageUploadViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *configureImages;
@property (nonatomic, strong) IBOutlet UIButton *viewImageSets;

@end
