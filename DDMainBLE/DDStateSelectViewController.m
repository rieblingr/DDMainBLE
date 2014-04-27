//
//  DDImageUploadViewController.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/22/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDStateSelectViewController.h"

@interface DDStateSelectViewController ()

@end

@implementation DDStateSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.states = [NSMutableArray arrayWithCapacity:6];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [self.states count];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"viewStateSetImages"])
	{
          NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DDStateImageSelectViewController *stateImageSelectVC = segue.destinationViewController;
        stateImageSelectVC.delegate = self;
        stateImageSelectVC.state = (int) indexPath.row;
        NSLog(@"The prepareForSegue viewStateSetImages executed in DDStateSelectViewController, state selected: %ld", (long)indexPath.row);
	}
}

- (void)didCancelStateImageSelect:(DDStateImageSelectViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didCreateImageArray:(NSData *)data
{
    NSLog(@"Did create Image Array DDStateSelectViewController");
    NSLog(@"SET THE DATA TO SOMETHING ");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate didCancelStateSelect:self];
}

@end
