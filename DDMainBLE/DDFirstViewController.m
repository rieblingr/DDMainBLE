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
    
    if([segue.identifier isEqualToString:@"manualStateImageSelect"])
    {
        DDManualImageViewController *ddManualImageVC = segue.destinationViewController;
        ddManualImageVC.delegate = self;
    }
    
    if([segue.identifier isEqualToString:@"gryoModeSelect"])
    {
        DDGyroModeViewController *ddGryoModeVC = segue.destinationViewController;
        ddGryoModeVC.delegate = self;
    }

}

- (void)didCancelManualMode:(DDManualImageViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didCancelGyroMode:(DDGyroModeViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
