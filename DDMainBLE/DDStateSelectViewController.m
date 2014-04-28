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
    NSString *state1 = @"Server State Image Set 1";
    [self.states addObject:state1];
    NSString *state2 = @"Server State Image Set 2";
    [self.states addObject:state2];
    NSString *state3 = @"Server State Image Set 3";
    [self.states addObject:state3];
    NSString *state4 = @"Server State Image Set 4";
    [self.states addObject:state4];
    NSString *state5 = @"Server State Image Set 5";
    [self.states addObject:state5];
    NSString *state6 = @"Server State Image Set 6";
    [self.states addObject:state6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.states count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DDCell";
    DDStateSetCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"DDCell"];
    if (cell == nil) {
        cell = (DDStateSetCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.imageStateValue.text = [self.states objectAtIndex:indexPath.row];
    return cell;
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
