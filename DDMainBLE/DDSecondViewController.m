//
//  DDSecondViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDSecondViewController.h"

@interface DDSecondViewController ()

@end

@implementation DDSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"configureImages"])
	{
		DDImageUploadViewController *ddImageUploadVC =
        segue.destinationViewController;
        ddImageUploadVC.delegate = self;
        NSLog(@"The prepareForSegue method executed in DDSecondVC");
	}
}

- (void) ddImageUploadVCDidCancel:(DDImageUploadViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
