//
//  DDImageUploadViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/22/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDImageUploadViewController.h"

@interface DDImageUploadViewController ()

@end

@implementation DDImageUploadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (IBAction)cancel:(id)sender
{
    [self.delegate ddImageUploadVCDidCancel:self];
}

@end
