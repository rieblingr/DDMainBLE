//
//  DDManualImageView.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDManualImageView.h"

@implementation DDManualImageView

- (id)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)buttons
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //button size is size of screen divided by the pixels of image
        self.BUTTON_SIZE = (CGFloat) ([[UIScreen mainScreen] bounds].size.width / IMAGE_WIDTH);
        
        //set draw to true (start state is in drawing state)
        
        //initialize array
        self.table = buttons;
        
        //now add all the buttons in subview
        for(int i = 0; i < IMAGE_HEIGHT; i++) {
            NSMutableArray *array = [buttons objectAtIndex:i];
            for(int j = 0; j < IMAGE_WIDTH; j++) {
                DDButtonCreateImage *button = [array objectAtIndex:j];
                [self addSubview:button];
            }
        }
        
        
        //make the buttons on the bottom
        self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        //get the height of the last button
        NSMutableArray *arr = [self.table objectAtIndex:[self.table count] - 1];
        UIButton *button = [arr objectAtIndex:0];
        
        CGFloat height = [button frame].origin.y + [button frame].size.height;
        
        //done button
        [self.sendButton setFrame:CGRectMake(([self frame].size.width / 2) - (CONTROL_WIDTH / 2), height + CONTROL_HEIGHT_OFFSET * 3, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [self.sendButton setTitle:@"Done" forState:UIControlStateNormal];
        [self addSubview:self.sendButton];
        
        //now set the targets to here
        [self.sendButton addTarget:self action:@selector(sendImage) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (IBAction)sendImage {
    NSLog(@"TEST");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
