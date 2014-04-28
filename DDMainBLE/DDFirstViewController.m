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
    
    [self.initiateExecutionBtn setEnabled:NO];
    [self.initiateExecutionBtn setAlpha:0.4F];
    [self.initiateExecutionBtn setTintColor:[UIColor blueColor]];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:[Server getState]
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* dataState = [json objectForKey:@"state"];
    NSArray* timeStamp = [json objectForKey:@"time"];
    
    NSLog(@"Json: %@", json);
    
    [self.serverStatus setText:[NSString stringWithFormat:@"Server: %@ at %@", dataState, timeStamp]];
    
    NSLog(@"ServerState: %@", dataState);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Server

- (void)updateServerLabel
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:[Server getState]
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* dataState = [json objectForKey:@"state"];
    NSArray* timeStamp = [json objectForKey:@"time"];
    
    NSLog(@"Json: %@", json);
    
    [self.serverStatus setText:[NSString stringWithFormat:@"Server: %@ at %@", dataState, timeStamp]];
    
    NSLog(@"ServerState: %@", dataState);
    
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
    
    if ([segue.identifier isEqualToString:@"startExecution"])
	{
        DDExecuteDiceViewController *ddExecuteDiceVC = segue.destinationViewController;
        ddExecuteDiceVC.delegate = self;
        
    }
}


- (void) ddBLEViewControllerDidCancel:(DDBLEViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) ddBLEViewControllerDidConnectSuccessful:(DDBLEViewController *)controller
{
    NSString *deviceName = controller.deviceName.text;
    
    [self.connectionStatus setText:@"Status: Connection Available"];
    [self.deviceConnection setText:deviceName];
    [self updateServerLabel];
    [self.initiateExecutionBtn setEnabled:YES];
    [self.initiateExecutionBtn setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    [self.initiateExecutionBtn setAlpha:1.0F];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void) ddExecuteDiceVCDidStop:(DDExecuteDiceViewController *)controller
{
    [self updateServerLabel];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didCancelManualMode:(DDManualImageViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
