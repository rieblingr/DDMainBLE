//
//  DDManualImageView.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDButtonCreateImage.h"
#import "DDSingletonArray.h"
#import "DDSingletonBluetooth.h"

#define IMAGE_WIDTH 32
#define IMAGE_HEIGHT 32
#define BUTTON_HEIGHT_OFFSET 0
#define CONTROL_WIDTH_OFFSET 15
#define CONTROL_HEIGHT_DIFF_OFFSET 5
#define CONTROL_WIDTH 100
#define CONTROL_HEIGHT 50

@protocol DDManualImageViewDelegate <NSObject>

-(void) sendBegin;
-(void) sendEnd;

@end

@interface DDManualImageView : UIView <DDSingletonBluetoothDelegate>

- (id)initWithFrame:(CGRect)frame withArray:(NSMutableArray *)buttons withBitmask:(char) bitmask;

@property char bitmask;

@property int state;
@property int imageSelected;

//delegate object
@property (weak, nonatomic) id<DDManualImageViewDelegate> delegate;

//now have the send button
@property (strong, nonatomic) UIButton *sendButton;

//table
@property (strong, nonatomic) NSMutableArray *table;

@property CGFloat BUTTON_SIZE;

@end
