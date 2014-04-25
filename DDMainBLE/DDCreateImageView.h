//
//  DDCreateImageView.h
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/25/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMAGE_WIDTH 32
#define IMAGE_HEIGHT 32

//This will be used to show an array of images
@interface DDCreateImageView : UIView

//This will carry the entire table of image buttons
@property (strong, nonatomic) NSMutableArray *table;

@end
