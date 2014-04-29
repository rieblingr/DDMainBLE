//
//  DDCreateImageView.h
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/25/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDButtonCreateImage.h"
#import "DDSingletonArray.h"

#define IMAGE_WIDTH 32
#define IMAGE_HEIGHT 28
#define BUTTON_HEIGHT_OFFSET 0
#define CONTROL_WIDTH_OFFSET 15
#define CONTROL_HEIGHT_OFFSET 40
#define CONTROL_WIDTH 100
#define CONTROL_HEIGHT 50

@protocol DDCreateImageViewDelegate <NSObject>

-(void) doneWithImage;

@end

//This will be used to show an array of images
@interface DDCreateImageView : UIView

//This will carry the entire table of image buttons
@property (strong, nonatomic) NSMutableArray *table;

@property CGFloat BUTTON_SIZE;

@property UIPanGestureRecognizer *pan;

@property BOOL isDraw;

@property (strong, nonatomic) UIButton *drawButton;

@property (strong, nonatomic) UIButton *eraseButton;

@property (strong, nonatomic) UIButton *eraseAllButton;

@property (strong, nonatomic) UIButton *doneButton;

//delegate object
@property (strong, nonatomic) id<DDCreateImageViewDelegate> delegate;

@property int state;
@property int imageSelected;

- (id)initWithFrame:(CGRect)frame withArray:(NSMutableArray*) buttons;

@end
