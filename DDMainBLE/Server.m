//
//  Server.m
//  DDMainBLE
//
//  Created by Kenneth Siu on 4/23/14.
//  Copyright (c) 2014 Ryan Riebling. All rights reserved.
//

#import "Server.h"

@implementation Server

NSString *url = @"http://kennethksiu.com:3000/DD";

+ (NSData*) setState:(NSNumber *)state time:(NSNumber *)number {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *urlSend =[NSURL URLWithString:[NSString stringWithFormat:@"%@/state/%i/%ld", url, [state intValue], [number longValue]]];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:urlSend] returningResponse:&urlResponse error:&requestError];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    return data;
}

+ (NSData*) getState {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *urlSend =[NSURL URLWithString:[NSString stringWithFormat:@"%@/state/get", url]];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:urlSend] returningResponse:&urlResponse error:&requestError];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    return data;
}

@end
