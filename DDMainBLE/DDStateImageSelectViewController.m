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

- (IBAction)setDefaultImages:(id)sender
{
    // Parse the digits text file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"6digitimage" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"File: %@", content);
    NSArray *images = [content componentsSeparatedByString:@"\n"];
    NSLog(@"Images array: %@", [images description]);
    
    for (int i = 0; i < 6; i++) {
       NSLog(@"Image %i: %@", i, [images objectAtIndex:i]);
        NSString *image = [[images objectAtIndex:i] description];
        [self setImage:image withIndex:i];
    }
}

- (BOOL)setImage:(NSString *)image withIndex:(int)imageIndex
{
    //save image into singleton
    DDSingletonArray *singleton = [DDSingletonArray singleton];
    self.defaultImage = [[NSMutableArray alloc] init];
    
    // Get an array of 1's and 0's
    NSArray *buttons = [image componentsSeparatedByString:@","];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];;
    
    for (int i = 0; i < [buttons count] && i < IMAGE_WIDTH * IMAGE_HEIGHT; i++) {
        // Need new temp array every new row
        if (i % IMAGE_WIDTH == 0) {
            NSLog(@"new array");
            tempArray = [[NSMutableArray alloc] init];
        }
        DDButtonCreateImage *button = [[DDButtonCreateImage alloc] init];
        
        if ([[buttons objectAtIndex:i] isEqualToString:@"1"]) {
            [button buttonDraw];
        } else {
            [button buttonErase];
        }
        
        [tempArray addObject:button];
        
        if (i > 0 && i % IMAGE_WIDTH == 0) {
            NSLog(@"Length temp: %lu", (unsigned long)[tempArray count]);
            [self.defaultImage addObject:tempArray];
            NSLog(@"Length image: %lu", (unsigned long)[self.defaultImage count]);
        }
    }
    //now add it to the particular array
    NSMutableArray *imagesArray = [singleton.array objectAtIndex:self.state];
    
    //add it
    [imagesArray removeObjectAtIndex:imageIndex];
    [imagesArray insertObject:self.defaultImage atIndex:imageIndex];
    
    return NO;
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
