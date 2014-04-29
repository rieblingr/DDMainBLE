//
//  DDSingletonArray.h
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDButtonCreateImage.h"

#define IMAGE_WIDTH 32
#define IMAGE_HEIGHT 28
#define BUTTON_HEIGHT_OFFSET 0

@interface DDSingletonArray : NSObject

@property NSMutableArray *array;

+(id)singleton;
+ (NSMutableArray*) makeData:(NSMutableArray*)table;

@end
