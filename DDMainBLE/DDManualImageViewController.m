//
//  DDManualImageViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDManualImageViewController.h"

@interface DDManualImageViewController ()

@end

@implementation DDManualImageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.sendingDataLabel setHidden:YES];
    [self.sendingDataIndicator setHidden:YES];
    
    [self updateServerLabel];
    
    //set char to 63 (all off since 1=off)
    self.bitmask = 63;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateServerLabel)
                                   userInfo:nil
                                    repeats:YES];
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
    
    NSString* dataState = (NSString*)[json objectForKey:@"state"];
    
    [self.serverStateLabel setText:[NSString stringWithFormat:@"Server State: %@", dataState]];
    
    if(self.state != [dataState intValue] && (self.currentButton != nil)) {
        self.state = [dataState intValue];
        [self showImagePreview:self.currentButton];
    }
    self.state = [dataState intValue];
}

#pragma mark - Navigation

- (NSMutableArray *)getDataArrayFromSingletonWith:(int) state andImageNumber:(int)imageSelected
{
    DDSingletonArray *singleton = [DDSingletonArray singleton];
    
    NSMutableArray *imageArray = [singleton.array objectAtIndex:(state - 1)];
    
    NSMutableArray *buttons = [imageArray objectAtIndex:(imageSelected - 1)];
    
    return buttons;
}

- (IBAction)showImagePreview:(id)sender
{
    if (![sender isKindOfClass:[UIButton class]])
        return;
    [self resetSendingDataUI];
    
    self.currentButton = (UIButton*)sender;
    
    NSString *buttonNumber = [[(UIButton *)sender titleLabel] text];
    NSLog(@"Button %@", buttonNumber);
    int imageSelected = [buttonNumber intValue];
    NSLog(@"Button %i clicked", imageSelected);
    
    NSMutableArray *imagePreview = [self getDataArrayFromSingletonWith:self.state andImageNumber:imageSelected];
    
    self.preview = [[DDManualImageView alloc] initWithFrame:self.preview.frame withArray:imagePreview];
    
    [self.view addSubview:self.preview];
    self.preview.delegate = self;
}

- (void)resetSendingDataUI
{
    [self.sendingDataLabel setHidden:NO];
    [self.sendingDataIndicator setHidden:YES];
    [self.sendingDataLabel setText:@"Ready To Send..."];
    [self.sendingDataLabel setTextColor:[UIColor blackColor]];
    
}

- (IBAction)cancel:(id)sender
{
    [self.delegate didCancelManualMode:self];
}


#pragma mark - DDManualImageViewDelgate

// Init UI Elements for BLE transfer
- (char)sendBegin
{
    [self.sendingDataLabel setHidden:NO];
    [self.sendingDataLabel setText:@"Now Sending Data..."];
    [self.sendingDataIndicator setHidden:NO];
    [self.sendingDataIndicator startAnimating];
    
    char bitmask = 63;
    
    //check which switches was set
    if([self.switch1 isOn]) {
        bitmask -= 1;
    }
    
    if([self.switch2 isOn]) {
        bitmask -= 2;
    }
    
    if([self.switch3 isOn]) {
        bitmask -= 4;
    }
    
    if([self.switch4 isOn]) {
        bitmask -= 8;
    }
    
    if([self.switch5 isOn]) {
        bitmask -= 16;
    }
    
    if([self.switch6 isOn]) {
        bitmask -= 32;
    }
    
    NSLog(@"Bitmask: %i", bitmask);
    
    return bitmask;
}

- (void)sendEnd
{
    [self.sendingDataLabel setText:@"Data Send Complete!"];
    [self.sendingDataIndicator stopAnimating];
    [self.sendingDataIndicator setHidden:YES];
    [self.sendingDataLabel setTextColor:[UIColor greenColor]];
}

@end
