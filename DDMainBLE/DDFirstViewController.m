//
//  DDFirstViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDFirstViewController.h"

@interface DDFirstViewController ()

@end

@implementation DDFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.initializeBLEBtn.layer setBorderWidth:1.0f];
    [self.initializeBLEBtn.layer setBorderColor:[[UIColor cyanColor] CGColor]];
    [self.initializeBLEBtn.layer setCornerRadius:15];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"connectBLE"])
	{
		DDBLEViewController *ddBLEViewController =
        segue.destinationViewController;
        ddBLEViewController.delegate = self;
	}
}


- (void) ddBLEViewControllerDidCancel:(DDBLEViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) ddBLEViewControllerDidSave:(DDBLEViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
