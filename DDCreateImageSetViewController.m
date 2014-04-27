//
//  DDCreateImageSetViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDCreateImageSetViewController.h"

@interface DDCreateImageSetViewController ()

@end

@implementation DDCreateImageSetViewController

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

- (void) ddCreateImageVC:(NSData*)data {
    //here is array from created image
    [self dismissViewControllerAnimated:YES completion:NULL];
//    DDAppDelegate *myAppDel = (DDAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [self.createdImage setImage:[UIImage imageWithData:data]];
//    NSLog(@"Array image: %@", self.createdImage.image);
//    myAppDel.imageArray = data;
    
}



@end
