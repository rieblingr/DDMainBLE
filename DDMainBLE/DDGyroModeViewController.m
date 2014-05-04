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
    
    //calculate screen width
    self.screenWidth = 245;
    
    //make bluetooth delegate
    DDSingletonBluetooth *bluetooth = [DDSingletonBluetooth singleton];
    
    //set delegate to self
    bluetooth.delegate = self;
    bluetooth.gyroDelegate = self;
    
    //set state to 0 (so it will call previews)
    self.state = 0;
    
    //set preview arrays
    self.previewArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 6; i++) {
        DDManualImageView *view = [[DDManualImageView alloc] init];
        [self.previewArray addObject:view];
        [self.view addSubview:view];
    }
    
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
    DDSingletonBluetooth *bluetooth =[DDSingletonBluetooth singleton];

    [bluetooth getGyroData];
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
            //remove from subview and array
            DDManualImageView *oldView = [self.previewArray objectAtIndex:j];
            
            //remove from view and remove in array
            [oldView removeFromSuperview];
            [self.previewArray removeObjectAtIndex:j];
            
            //get image array based off that
            NSMutableArray *imageArray = [tempArray objectAtIndex:j];
            
            char bitmask = 63;
            bitmask -= (char)pow(2, j);
            
            int varWidthOffset = (j % 3);
            
            int height = 0;
            
            //set height to 1 if image is on the second row
            if(j > 2) {
                height = 1;
            }
            
            CGRect rect = CGRectMake(IMAGE_WIDTH_OFFSET * (varWidthOffset + 1) + (varWidthOffset * self.screenWidth),
                (IMAGE_HEIGHT_OFFSET) + (self.screenWidth * height) + (IMAGE_HEIGHT_BETWEEN_OFFSET * height),
                 self.screenWidth,
                 self.screenWidth);
            
            //set image array before sending through bluetooth
            DDManualImageView *view = [[DDManualImageView alloc] initWithFrame:rect withArray:imageArray];
            
            //hide hidden button
            [view.sendButton setHidden:YES];
            
            [self.view addSubview:view];
            
            //also readd to array
            [self.previewArray insertObject:view atIndex:j];
            
            //now update cube (bitmask is based on the char we're on
            [bluetooth startTransferWithArray:imageArray withBitmask:bitmask];
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
