//
//  BBCErrorHandler.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCErrorHandler.h"

@implementation BBCErrorHandler

+ (void)handleError:(NSError *)error{
    NSString *tittle;
    if ([error code] == kCFURLErrorNotConnectedToInternet){
        tittle = @"Connection error";
    } else {
        tittle = @"Server Error";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:tittle message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end
