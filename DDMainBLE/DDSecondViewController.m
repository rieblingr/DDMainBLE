//
//  DDSecondViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/21/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDSecondViewController.h"
#import "Server.h"

@interface DDSecondViewController ()

@end

@implementation DDSecondViewController
@synthesize BUTTON_SIZE;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    [self updateServerLabel];
    
    //make NSTimer that updates the server periodically
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateServerLabel)
                                   userInfo:nil
                                    repeats:NO];
    //button size is size of screen divided by the pixels of image
    BUTTON_SIZE = (CGFloat) ([[UIScreen mainScreen] bounds].size.width / IMAGE_WIDTH);
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
    
    NSString* dataState = [json objectForKey:@"state"];
    
    [self.serverStateLabel setText:[NSString stringWithFormat:@"Current Server State: %@", dataState]];
}

#pragma mark - Set State Images

- (IBAction)setDefaultImages:(id)sender
{
    // Set all 6 server image sets
    for (int x = 1; x < 7; x++) {
        // Parse the digits text file
        self.state = x - 1;
        NSString *digitFileName = [NSString stringWithFormat:@"digit%iimage", x];
        NSString *path = [[NSBundle mainBundle] pathForResource:digitFileName ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        //NSLog(@"File: %@", content);
        NSArray *images = [content componentsSeparatedByString:@"\n"];
        //NSLog(@"Images array: %@", [images description]);
        
        for (int i = 0; i < 6; i++) {
            //NSLog(@"Image %i: %@", i, [images objectAtIndex:i]);
            NSString *image = [[images objectAtIndex:i] description];
            [self setImage:image withIndex:i];
        }
    }
    
    // On completion show alert box
    self.statusAlert = [[UIAlertView alloc] initWithTitle:@"Image Load Complete!"
                                                    message:@"You now have default image sets for each server state."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [self.statusAlert show];
}

- (BOOL)setImage:(NSString *)image withIndex:(int)imageIndex
{
    //save image into singleton
    DDSingletonArray *singleton = [DDSingletonArray singleton];
    self.defaultImage = [[NSMutableArray alloc] init];
    
    // Get an array of 1's and 0's
    NSArray *buttons = [image componentsSeparatedByString:@","];
    
    for(int i = 0; i < IMAGE_HEIGHT; i++) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for(int j = 0; j < IMAGE_WIDTH; j++) {
            DDButtonCreateImage *button = [[DDButtonCreateImage alloc] initWithFrame:CGRectMake(j * BUTTON_SIZE, (i * BUTTON_SIZE) + BUTTON_HEIGHT_OFFSET, BUTTON_SIZE, BUTTON_SIZE)];
            
            if ([[buttons objectAtIndex:(j+(32*i))] isEqualToString:@"1"]) {
                [button buttonDraw];
            } else {
                [button buttonErase];
            }
            [tempArray addObject:button];
            //   NSLog(@"Length temp: %lu", (unsigned long)[tempArray count]);
        }
        
        [self.defaultImage addObject:tempArray];
        // NSLog(@"Length image: %lu", (unsigned long)[self.defaultImage count]);
    }
    
    //now add it to the particular array
    NSMutableArray *imagesArray = [singleton.array objectAtIndex:self.state];
    
    //add it
    [imagesArray removeObjectAtIndex:imageIndex];
    [imagesArray insertObject:self.defaultImage atIndex:imageIndex];
    
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.statusAlert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"viewImageSets"])
	{
        UINavigationController *navigationController =
        segue.destinationViewController;
		DDStateSelectViewController *stateSelectVC =
        [[navigationController viewControllers]
         objectAtIndex:0];
        stateSelectVC.delegate = self;
        NSLog(@"The prepareForSegue viewImageSets executed in DDSecondVC");
	}
}

- (void) didCancelStateSelect:(DDStateSelectViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
