//
//  DDSecondViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDSecondViewController.h"
#import "Server.h"

@interface DDSecondViewController ()

@end

@implementation DDSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    [self updateServerLabel];
    
    //make NSTimer that updates the server periodically
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                    target:self
                                   selector:@selector(updateServerLabel)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Server

- (IBAction)updateServerLabel
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:[Server getState]
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* dataState = [json objectForKey:@"state"];
    
    NSLog(@"Json: %@", json);
    
    [self.serverStateLabel setText:[NSString stringWithFormat:@"Current Server State: %@", dataState]];
    
    NSLog(@"ServerState: %@", dataState);
    
}

#pragma mark - Navigation

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

@end
