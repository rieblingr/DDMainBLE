//
//  Server.h
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/23/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject
+ (NSData*) setState:(NSString*)state time:(NSNumber*)number;
+ (NSData*) getState;

@end
