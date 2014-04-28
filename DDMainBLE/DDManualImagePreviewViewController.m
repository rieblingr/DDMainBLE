//
//  DDManualImagePreviewViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDManualImagePreviewViewController.h"



@interface DDManualImagePreviewViewController ()

@end

@implementation DDManualImagePreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //grab array
    
    NSMutableArray *array = ((DDSingletonArray*)[DDSingletonArray singleton]).array;
    
    //now using state and imageSelected
    NSMutableArray *imageArrayForSet = [array objectAtIndex:self.state - 1];
    
    //now get array for button
    NSMutableArray *buttonForImage = [imageArrayForSet objectAtIndex:self.imageSelected - 1];
    
    DDManualImageView *createView =[[DDManualImageView alloc] initWithFrame:CGRectMake(0, 44, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64) withArray:buttonForImage];
    
    createView.state = self.state;
    createView.delegate = self;
    createView.imageSelected = self.imageSelected;
    [self.view addSubview:createView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender
{
    [self.delegate didCancel:self];
}

//delegate for manual image view
-(void) sendPicture {
    [self.delegate didCancel:self];
}

@end
