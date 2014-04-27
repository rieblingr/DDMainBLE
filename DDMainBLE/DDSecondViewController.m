//
//  DDSecondViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDSecondViewController.h"
#import "DDExecuteDiceViewController.h"
#import "DDCreateImageSetViewController.h"

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
        UINavigationController *navigationController =
        segue.destinationViewController;
		DDImageUploadViewController *ddImageUploadVC =
        [[navigationController viewControllers]
         objectAtIndex:0];
        ddImageUploadVC.delegate = self;
        NSLog(@"The prepareForSegue configureImages executed in DDSecondVC");
	}
    
    if ([segue.identifier isEqualToString:@"createImage"])
	{
		DDCreateImageSetViewController *ddCreateImageSetVC =
        segue.destinationViewController;
        ddCreateImageSetVC.delegate = self;
        NSLog(@"The prepareForSegue createImage executed in DDSecondVC");
	}
}

- (void) ddImageUploadVCDidCancel:(DDImageUploadViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//create image view controller delegate functions

- (void) ddCreateImageVCDidCancel:(DDCreateImageViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
