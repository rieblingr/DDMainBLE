//
//  DDButtonCreateImage.m
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/25/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DDButtonCreateImage.h"

@implementation DDButtonCreateImage

@synthesize isPressed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //set the state of pressed to no
        isPressed = NO;
        
        //set border to black and background to white
        [self setBackgroundColor:[UIColor whiteColor]];
        CALayer * layer = [self layer];
        
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:0.0]; //when radius is 0, the border is a rectangle
        [layer setBorderWidth:1.0];
        [layer setBorderColor:[[UIColor blackColor] CGColor]];
    }
    return self;
}

-(void) buttonDraw {
    //button draw
    [self setBackgroundColor:[UIColor blackColor]];
    isPressed = YES;
}

-(void) buttonErase {
    //button is erased
    [self setBackgroundColor:[UIColor whiteColor]];
    isPressed = NO;
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
