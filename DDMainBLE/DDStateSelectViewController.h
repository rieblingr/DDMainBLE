//
//  DDImageUploadViewController.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/22/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDStateImageSelectViewController.h"
#import "DDStateSetCell.h"

@class DDStateSelectViewController;

@protocol DDStateSelectDelegate <NSObject>

- (void) didCancelStateSelect: (DDStateSelectViewController *)controller;

@end

@interface DDStateSelectViewController : UITableViewController<DDStateImageSelectDelegate>

@property (nonatomic, strong) NSMutableArray *states;

@property (nonatomic, weak) id <DDStateSelectDelegate> delegate;

- (IBAction)done:(id)sender;

@end
