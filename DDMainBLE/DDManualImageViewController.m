//
//  DDManualImageViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDManualImageViewController.h"
#import "DDManualImagePreviewViewController.h"

@interface DDManualImageViewController ()

@end

@implementation DDManualImageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    if ([segue.identifier isEqualToString:@"previewImage1"])  {
        DDManualImagePreviewViewController *ddManualImagePreviewVC = segue.destinationViewController;
        ddManualImagePreviewVC.state = self.state;
        ddManualImagePreviewVC.imageSelected = 1;
        ddManualImagePreviewVC.delegate = self;
        NSLog(@"Segue to preview image: %i", 1);
    }
    if ([segue.identifier isEqualToString:@"previewImage2"])  {
        DDManualImagePreviewViewController *ddManualImagePreviewVC = segue.destinationViewController;
        ddManualImagePreviewVC.state = self.state;
        ddManualImagePreviewVC.imageSelected = 2;
        ddManualImagePreviewVC.delegate = self;
        NSLog(@"Segue to image: %i", 2);
    }
    if ([segue.identifier isEqualToString:@"previewImage3"])  {
        DDManualImagePreviewViewController *ddManualImagePreviewVC = segue.destinationViewController;
        ddManualImagePreviewVC.state = self.state;
        ddManualImagePreviewVC.imageSelected = 3;
        ddManualImagePreviewVC.delegate = self;
        NSLog(@"Segue to preview image: %i", 3);
    }
    if ([segue.identifier isEqualToString:@"previewImage4"])  {
        DDManualImagePreviewViewController *ddManualImagePreviewVC = segue.destinationViewController;
        ddManualImagePreviewVC.state = self.state;
        ddManualImagePreviewVC.imageSelected = 4;
        ddManualImagePreviewVC.delegate = self;
        NSLog(@"Segue to preview image: %i", 4);
    }
    if ([segue.identifier isEqualToString:@"previewImage5"])  {
        DDManualImagePreviewViewController *ddManualImagePreviewVC = segue.destinationViewController;
        ddManualImagePreviewVC.state = self.state;
        ddManualImagePreviewVC.imageSelected = 5;
        ddManualImagePreviewVC.delegate = self;
        NSLog(@"Segue to preview image: %i", 5);
    }
    if ([segue.identifier isEqualToString:@"previewImage6"])  {
        DDManualImagePreviewViewController *ddManualImagePreviewVC = segue.destinationViewController;
        ddManualImagePreviewVC.state = self.state;
        ddManualImagePreviewVC.imageSelected = 6;
        ddManualImagePreviewVC.delegate = self;
        NSLog(@"Segue to preview image: %i", 6);
    }

}

- (void)didCancel:(DDManualImagePreviewViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate didCancelManualMode:self];
}

@end
