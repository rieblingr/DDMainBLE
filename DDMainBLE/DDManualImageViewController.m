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
    [self.sendingDataProgress setHidden:YES];
    
    [self updateServerLabel];
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
    
    NSString* dataState = (NSString*)[json objectForKey:@"state"];
    
    NSLog(@"Json: %@", json);
    
    [self.serverStateLabel setText:[NSString stringWithFormat:@"Server State: %@", dataState]];
    
    self.state = [dataState intValue];
    
    NSLog(@"ServerState: %@", dataState);
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

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
    NSString *buttonNumber = [[(UIButton *)sender titleLabel] text];
    NSLog(@"Button %@", buttonNumber);
    int imageSelected = [buttonNumber intValue];
    NSLog(@"Button %i clicked", imageSelected);
    
    NSMutableArray *imagePreview = [self getDataArrayFromSingletonWith:self.state andImageNumber:imageSelected];
    
        self.preview = [[DDManualImageView alloc] initWithFrame:self.preview.frame withArray:imagePreview];
   
    [self.view addSubview:self.preview];
     self.preview.layer.borderWidth = 3.0f;
    self.preview.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
}

- (IBAction)cancel:(id)sender
{
    [self.delegate didCancelManualMode:self];
}

@end
