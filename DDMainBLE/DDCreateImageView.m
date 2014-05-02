//
//  DDCreateImageView.m
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/25/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDCreateImageView.h"

@implementation DDCreateImageView

@synthesize table, BUTTON_SIZE, pan, isDraw, drawButton, eraseButton, eraseAllButton, doneButton, delegate;

- (id)initWithFrame:(CGRect)frame withArray:(NSMutableArray*) buttons
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //button size is size of screen divided by the pixels of image
        BUTTON_SIZE = (CGFloat) ([[UIScreen mainScreen] bounds].size.width / IMAGE_WIDTH);
        
        //set draw to true (start state is in drawing state)
        isDraw = YES;
        
        //initialize array
        table = buttons;
        
        //now add all the buttons in subview
        for(int i = 0; i < IMAGE_HEIGHT; i++) {
            NSMutableArray *array = [buttons objectAtIndex:i];
            for(int j = 0; j < IMAGE_WIDTH; j++) {
                DDButtonCreateImage *button = [array objectAtIndex:j];
                if(i < 28) {
                   [self addSubview:button];
                }
            }
        }
        
        //pan recognizer
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRec:)];
        self.gestureRecognizers = @[pan];
        
        
        //make the buttons on the bottom
        drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        eraseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        eraseAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        //get the height of the last button
        NSMutableArray *arr = [table objectAtIndex:[table count] - 1];
        UIButton *button = [arr objectAtIndex:0];
        
        CGFloat height = [button frame].origin.y + [button frame].size.height;
        
        //draw button initialization
        [drawButton setFrame:CGRectMake(CONTROL_WIDTH_OFFSET, height + CONTROL_HEIGHT_OFFSET, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [drawButton setTitle:@"Draw" forState:UIControlStateNormal];
        [drawButton setBackgroundColor:[UIColor lightGrayColor]];
        [drawButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:drawButton];
        
        //erase all button
        [eraseAllButton setFrame:CGRectMake(([self frame].size.width / 2) - (CONTROL_WIDTH), height + CONTROL_HEIGHT_OFFSET, CONTROL_WIDTH * 2, CONTROL_HEIGHT)];
        [eraseAllButton setTitle:@"Erase All" forState:UIControlStateNormal];
        [eraseAllButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:eraseAllButton];
        
        
        //erase button initialization
        [eraseButton setFrame:CGRectMake([self bounds].size.width - CONTROL_WIDTH_OFFSET - CONTROL_WIDTH, height + CONTROL_HEIGHT_OFFSET, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [eraseButton setTitle:@"Erase" forState:UIControlStateNormal];
        [eraseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:eraseButton];
        
        //done button
        [doneButton setFrame:CGRectMake(([self frame].size.width / 2) - (CONTROL_WIDTH / 2), height + CONTROL_HEIGHT_OFFSET * 3, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [[doneButton titleLabel] setFont:[UIFont systemFontOfSize:32.0]];
        [self addSubview:doneButton];
        
        //now set the targets to here
        [drawButton addTarget:self action:@selector(drawPressed:) forControlEvents:UIControlEventTouchDown];
        [eraseAllButton addTarget:self action:@selector(eraseAllPressed:) forControlEvents:UIControlEventTouchDown];
        [eraseButton addTarget:self action:@selector(erasePressed:) forControlEvents:UIControlEventTouchDown];
        [doneButton addTarget:self action:@selector(makeArray) forControlEvents:UIControlEventTouchDown];
        
    }
    return self;
}

-(IBAction)drawPressed:(UIButton*)button {
    //draw pressed so set it to gray
    [drawButton setBackgroundColor:[UIColor lightGrayColor]];
    [eraseButton setBackgroundColor:[UIColor clearColor]];
    isDraw = YES;
}

-(IBAction)eraseAllPressed:(UIButton*) button {
    //erase all pressed so erase everything
    for(int i = 0 ; i < IMAGE_HEIGHT; i++) {
        NSMutableArray *tempArr = [table objectAtIndex:i];
        for(int j = 0; j < IMAGE_WIDTH; j++) {
            //get button
            DDButtonCreateImage *temp = [tempArr objectAtIndex:j];
            [temp buttonErase];
        }
    }
}

-(IBAction)erasePressed:(UIButton*)button {
    //erase pressed so set it to gray
    [eraseButton setBackgroundColor:[UIColor lightGrayColor]];
    [drawButton setBackgroundColor:[UIColor clearColor]];
    isDraw = NO;
    
}

- (IBAction)panRec:(UIPanGestureRecognizer*)gesture {
    CGPoint translation = [gesture locationInView:self.superview];
    
    [self findButtons:translation];
}

- (void) findButtons : (CGPoint) point {
    for(int i = 0; i < IMAGE_HEIGHT; i++) {
        NSMutableArray *tempArr = [table objectAtIndex:i];
        for(int j = 0; j < IMAGE_WIDTH; j++) {
            //get button
            DDButtonCreateImage *temp = [tempArr objectAtIndex:j];
            
            //first check to see if height is within bounds, if not, break from loop
            
            if( !(([temp frame].origin.y + 44 <= point.y) &&
                  ([temp frame].origin.y + [temp frame].size.height + 44) >= point.y) ) {
                break;
            }
            
            if( ([temp frame].origin.x <= point.x) &&
               (([temp frame].origin.x + [temp frame].size.width) >= point.x) ) {
                //then we know that touch is in button so set it
                if(isDraw) {
                    [temp buttonDraw];
                } else {
                    [temp buttonErase];
                }
                
            }
            
        }
    }
}

- (void) makeButtons {
    
    for(int i = 0; i < IMAGE_HEIGHT; i++) {
        //initialize table with another array
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int j = 0; j < IMAGE_WIDTH; j++) {
            //now add a button to the respective spot
            DDButtonCreateImage *button = [[DDButtonCreateImage alloc] initWithFrame:CGRectMake(j * BUTTON_SIZE, (i * BUTTON_SIZE) + BUTTON_HEIGHT_OFFSET, BUTTON_SIZE, BUTTON_SIZE)];
            
            [self addSubview:button];
            
            //also add to the array
            [array addObject:button];
        }
        
        //now add array to the top level array
        [table addObject:array];
    }
}

- (IBAction) makeArray {
    //save image into singleton
    DDSingletonArray *singleton = [DDSingletonArray singleton];
    
    //now add it to the particular array
    NSMutableArray *imagesArray = [singleton.array objectAtIndex:self.state - 1];
    
    //add it
    [imagesArray removeObjectAtIndex:self.imageSelected - 1];
    [imagesArray insertObject:table atIndex:self.imageSelected - 1];
    
    // Uncomment for logging image into text
    /*
    NSString *imageString = @"";
    
    for(int i = 0; i < IMAGE_HEIGHT; i++) {
        NSMutableArray *tempArray = [table objectAtIndex:i];
        for(int j = 0; j < IMAGE_WIDTH; j++) {
            DDButtonCreateImage *button = [tempArray objectAtIndex:j];
            
            if([button isPressed]) {
                imageString = [imageString stringByAppendingString:@"1,"];
            } else {
                imageString = [imageString stringByAppendingString:@"0,"];
            }
        }
    }
    
    NSLog(@"Image to text: %@", imageString);
     */
    
    //call delegate
    [delegate doneWithImage];
    
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
