//
//  DDStateImageViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDStateImageSelectViewController.h"

@interface DDStateImageSelectViewController ()

@end

@implementation DDStateImageSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Setting Label to server state: %i", self.state + 1);
    self.imageSetLabel.text = [self.imageSetLabel.text stringByAppendingString:[NSString stringWithFormat:@"%i", self.state + 1]];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"setImage1"])  {
        DDCreateImageViewController *ddCreateImageVC = segue.destinationViewController;
        ddCreateImageVC.state = self.state + 1;
        ddCreateImageVC.imageSelected = 1;
        ddCreateImageVC.delegate = self;
        NSLog(@"Segue to image: %i", 1);
    }
    if ([segue.identifier isEqualToString:@"setImage2"])  {
        DDCreateImageViewController *ddCreateImageVC = segue.destinationViewController;
        ddCreateImageVC.state = self.state + 1;
        ddCreateImageVC.imageSelected = 2;
        ddCreateImageVC.delegate = self;
        NSLog(@"Segue to image: %i", 2);
    }
    if ([segue.identifier isEqualToString:@"setImage3"])  {
        DDCreateImageViewController *ddCreateImageVC = segue.destinationViewController;
        ddCreateImageVC.state = self.state + 1;
        ddCreateImageVC.imageSelected = 3;
        ddCreateImageVC.delegate = self;
        NSLog(@"Segue to image: %i", 3);
    }
    if ([segue.identifier isEqualToString:@"setImage4"])  {
        DDCreateImageViewController *ddCreateImageVC = segue.destinationViewController;
        ddCreateImageVC.state = self.state + 1;
        ddCreateImageVC.imageSelected = 4;
        ddCreateImageVC.delegate = self;
        NSLog(@"Segue to image: %i", 4);
    }
    if ([segue.identifier isEqualToString:@"setImage5"])  {
        DDCreateImageViewController *ddCreateImageVC = segue.destinationViewController;
        ddCreateImageVC.state = self.state + 1;
        ddCreateImageVC.imageSelected = 5;
        ddCreateImageVC.delegate = self;
        NSLog(@"Segue to image: %i", 5);
    }
    if ([segue.identifier isEqualToString:@"setImage6"])  {
        DDCreateImageViewController *ddCreateImageVC = segue.destinationViewController;
        ddCreateImageVC.state = self.state + 1;
        ddCreateImageVC.imageSelected = 6;
        ddCreateImageVC.delegate = self;
        NSLog(@"Segue to image: %i", 6);
    }
    
}

- (void)ddCreateImageVCDidCancel:(DDCreateImageViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)cancel:(id)sender
{
    [self.delegate didCancelStateImageSelect:self];
}

- (IBAction)done:(id)sender
{
    [self.delegate didCancelStateImageSelect:self];
}

@end
