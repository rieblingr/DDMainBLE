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

+ (NSData*) makeData:(NSMutableArray*)table {
    char bytes[128];
    
    int countByteIndex = 0;
    
    //i represents the page it is currently on
    for(int i = 0; i < 4; i++) {
        //for each column
        for(int j = 0; j < IMAGE_WIDTH; j++) {
            int count[8];
            int index = 0;
            //this is the starting from the bottom of the column
            for(int k = (i * 7) + 7; k >= (i * 7); k--) {
                NSMutableArray *tempArr = [table objectAtIndex:k];
                DDButtonCreateImage *button = [tempArr objectAtIndex:j];
                
                if([button isPressed]) {
                    count[index] = 1;
                } else {
                    count[index] = 0;
                }
                index++;
            }
            
            //make the count into NSData and add
            
            //now make the NSData using the information
            int tempNum = 0;
            
            for(int i = 0; i < 8; i++) {
                tempNum += (count[i] * pow(2, (7 - i)));
            }
            
            //add to byte array
            bytes[countByteIndex] = (char) tempNum;
            
            countByteIndex++;
        }
    }
    
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    
    return data;
}

@end
