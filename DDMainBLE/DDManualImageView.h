//
//  DDManualImageView.h
//  DDMainBLE
//
//  Created by Ryan Riebling on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDButtonCreateImage.h"

#define IMAGE_WIDTH 32
#define IMAGE_HEIGHT 32
#define BUTTON_HEIGHT_OFFSET 0
#define CONTROL_WIDTH_OFFSET 15
#define CONTROL_HEIGHT_OFFSET 20
#define CONTROL_WIDTH 50
#define CONTROL_HEIGHT 20

@protocol DDManualImageViewDelegate <NSObject>

-(void) sendPicture;

@end

@interface DDManualImageView : UIView

- (id)initWithFrame:(CGRect)frame withArray:(NSMutableArray*) buttons;

@property int state;
@property int imageSelected;

//delegate object
@property (strong, nonatomic) id<DDManualImageViewDelegate> delegate;

//now have the send button
@property (strong, nonatomic) UIButton *sendButton;

//table
@property (weak, nonatomic) NSMutableArray *table;

@property CGFloat BUTTON_SIZE;

@end
