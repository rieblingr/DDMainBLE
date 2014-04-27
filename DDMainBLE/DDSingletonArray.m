//
//  DDSingletonArray.m
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/27/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "DDSingletonArray.h"

@implementation DDSingletonArray

+(id)singleton {
    static DDSingletonArray *singleton;
    static dispatch_once_t once;
    dispatch_once (&once, ^{
        singleton = [[self alloc] init];
        singleton.array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 6; i++) {
            NSMutableArray *stateArray = [[NSMutableArray alloc] init];
            
            //add 6 button images into it
            for(int j = 0; j < 6; j++) {
                [stateArray addObject:[self makeButtons]];
            }
            
            //now add the state array
            [singleton.array addObject:stateArray];
        }
    });
    
    return singleton;
}

+(NSMutableArray*) makeButtons {
    CGFloat BUTTON_SIZE = (CGFloat) ([[UIScreen mainScreen] bounds].size.width / IMAGE_WIDTH);
    NSMutableArray *returnArray;
    for(int i = 0; i < IMAGE_HEIGHT; i++) {
        //initialize table with another array
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int j = 0; j < IMAGE_WIDTH; j++) {
            //now add a button to the respective spot
            DDButtonCreateImage *button = [[DDButtonCreateImage alloc] initWithFrame:CGRectMake(j * BUTTON_SIZE, (i * BUTTON_SIZE) + BUTTON_HEIGHT_OFFSET, BUTTON_SIZE, BUTTON_SIZE)];
                        
            //also add to the array
            [array addObject:button];
        }
        
        //now add array to the top level array
        [returnArray addObject:array];
    }
    
    return returnArray;
}

@end
