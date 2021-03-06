//
//  DDManualImageView.m
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDManualImageView.h"

@implementation DDManualImageView

@synthesize BUTTON_SIZE;

- (id)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)buttons
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //button size is size of screen divided by the pixels of image
        self.BUTTON_SIZE = (CGFloat) (frame.size.width / IMAGE_WIDTH);
        
        //initialize arrayd
        self.table = [[NSMutableArray alloc] init];
        
        //now add all the buttons in subview
        for(int i = 0; i < IMAGE_HEIGHT; i++) {
            NSMutableArray *array = [buttons objectAtIndex:i];
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for(int j = 0; j < IMAGE_WIDTH; j++) {
                DDButtonCreateImage *button = [array objectAtIndex:j];
                
                DDButtonCreateImage *buttonCopy = [[DDButtonCreateImage alloc] initWithFrame:CGRectMake(j * BUTTON_SIZE, (i * BUTTON_SIZE) + BUTTON_HEIGHT_OFFSET, BUTTON_SIZE,BUTTON_SIZE)];
                
                if([button isPressed]) {
                    [buttonCopy buttonDraw];
                } else {
                    [buttonCopy buttonErase];
                }
                
                [tempArr addObject:buttonCopy];
                
                if(i < 28) {
                    [self addSubview:buttonCopy];
                }
            }
            
            //now add to table
            [self.table addObject:tempArr];
        }
        
        
        //make the buttons on the bottom
        self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        //get the height of the last button
        NSMutableArray *arr = [self.table objectAtIndex:[self.table count] - 1];
        UIButton *button = [arr objectAtIndex:0];
        
        CGFloat height = [button frame].origin.y + [button frame].size.height;
        
        //send button
        [self.sendButton setFrame:CGRectMake(([self frame].size.width / 2) - (CONTROL_WIDTH / 2), height + CONTROL_HEIGHT_DIFF_OFFSET * 3, CONTROL_WIDTH, CONTROL_HEIGHT)];
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [[self.sendButton titleLabel] setFont:[UIFont systemFontOfSize:32.0]];
        
        [self addSubview:self.sendButton];
        
        //now set the targets to here
        [self.sendButton addTarget:self action:@selector(sendImage) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (IBAction)sendImage {
    
    //initialize bluetooth and set delegate to self
    DDSingletonBluetooth *bluetooth = [DDSingletonBluetooth singleton];
    bluetooth.delegate = self;
    
    //send the view's delegate that it began sending
    char returned = [self.delegate sendBegin];
    
    //begin tranfser of the bluetooth
    [bluetooth startTransferWithArray:self.table withBitmask:returned];
}

-(void) finishedSending {
    //when the bluetooth is done sending, send the view's delegate that it has finished
    [self.delegate sendEnd];
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
