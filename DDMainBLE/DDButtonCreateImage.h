//
//  DDButtonCreateImage.h
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/25/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDButtonCreateImage : UIButton

@property (nonatomic) BOOL isPressed;

-(void) buttonDraw;
-(void) buttonErase;
@end
