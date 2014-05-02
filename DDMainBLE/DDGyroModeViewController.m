//
//  DDGryoModeViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDGyroModeViewController.h"

@interface DDGyroModeViewController ()

@end

@implementation DDGyroModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //make bluetooth delegate
    DDSingletonBluetooth *bluetooth = [DDSingletonBluetooth singleton];
    
    //set delegate to self
    bluetooth.delegate = self;
    bluetooth.gyroDelegate = self;
    
    [self updateServerLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateServerLabel) userInfo:nil repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateGyroData) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gyro Data
- (IBAction) updateGyroData {
    NSLog(@"Updating Gyro Data");
}

#pragma mark - Server

- (IBAction)updateServerLabel
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:[Server getState]
                          
                          options:kNilOptions
                          error:&error];
    
    NSString* dataState = (NSString*)[json objectForKey:@"state"];
    
    int tempState = [dataState intValue];
    
    if(tempState != self.state) {
        //use to update the cube
        DDSingletonBluetooth *bluetooth = [DDSingletonBluetooth singleton];
        
        [self.serverStateLabel setText:[NSString stringWithFormat:@"Server State: %@", dataState]];
        
        self.state = [dataState intValue];
        
        //now set the images to that state
        DDSingletonArray *singleton = [DDSingletonArray singleton];
        
        //get image set for the current state
        NSMutableArray *tempArray = [singleton.array objectAtIndex:self.state - 1];
        
        for(char j = 0; j < 6; j++) {
            //get image array based off that
            NSMutableArray *imageArray = [tempArray objectAtIndex:j];
            
            //now update cube (bitmask is based on the char we're on
            [bluetooth startTransferWithArray:imageArray withBitmask:(char)pow(2, j)];
        }
    }
}

- (IBAction)setServerLabel:(NSString*) state {
    NSError *error;
    
    NSNumber *currDate = [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[Server setState:state time:currDate] options:kNilOptions error:&error];
    
    BOOL success = [[json objectForKey:@"success"] boolValue];
    
    if(success) {
        NSLog(@"Successfully set state");
        [self.serverStateLabel setText:[NSString stringWithFormat:@"Server State: %@", state]];
        
    } else {
        NSLog(@"ERROR SETTING STATE");
    }
}

#pragma mark - DDSingletonBluetooth

- (void)finishedSending
{
    
}

#pragma mark - DDSingletonGyroBluetooth
- (void) receivedXValue:(unsigned char*)xValue {
    self.xGyro = xValue;
}

- (void) receivedYValue:(unsigned char*)yValue {
    self.yGyro = yValue;
}

- (void) receivedZValue:(unsigned char*)zValue {
    self.zGyro = zValue;
}

- (IBAction)cancel:(id)sender
{
    [self.delegate didCancelGyroMode:self];
}

@end
