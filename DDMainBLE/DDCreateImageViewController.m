//
//  DDCreateImageViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/24/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDCreateImageViewController.h"

@interface DDCreateImageViewController ()

@end

@implementation DDCreateImageViewController

@synthesize createView, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//delegate function
- (void) ddCreateImage:(NSData *)data {
    //send to the next delegate
    [delegate ddCreateImageVC:data];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    createView =[[DDCreateImageView alloc] initWithFrame:CGRectMake(0, 44, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64)];
    createView.delegate = self;
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
    NSLog(@"Cancel create image selected");
    [self.delegate ddCreateImageVCDidCancel:self];
}

@end
