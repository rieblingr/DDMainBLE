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
	if ([segue.identifier isEqualToString:@"viewImageSets"])
	{
        UINavigationController *navigationController =
        segue.destinationViewController;
		DDStateSelectViewController *stateSelectVC =
        [[navigationController viewControllers]
         objectAtIndex:0];
        stateSelectVC.delegate = self;
        NSLog(@"The prepareForSegue viewImageSets executed in DDSecondVC");
	}
}

- (void) didCancelStateSelect:(DDStateSelectViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//create image view controller delegate functions
- (void) ddCreateImageVCDidCancel:(DDCreateImageViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
