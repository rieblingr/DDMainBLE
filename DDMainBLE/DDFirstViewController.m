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
    
    int8_t data = 0x1;
    NSData *dummyData = [[NSData alloc] init];
    dummyData = [NSData dataWithBytes:&data length:sizeof(data)];
    [self setServerState: dummyData];
    [self checkServerState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Server

- (void)checkServerState
{
    self.serverState = [Server getState];
    [self.serverStatus setText:[NSString stringWithFormat:@"Server: %@", self.serverState]];
}

- (void)setServerState:(NSData *)serverState
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampNumber = [NSNumber numberWithDouble: timeStamp];
    // State of 1 is iOS device?
    [Server setState:@"1" time:timeStampNumber];
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
    [self checkServerState];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) ddBLEViewControllerDidConnectSuccessful:(DDBLEViewController *)controller
{
    NSString *deviceName = controller.deviceName.text;
    
    [self.connectionStatus setText:@"Status: Connection Available"];
    [self.deviceConnection setText:deviceName];
    [self checkServerState];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
