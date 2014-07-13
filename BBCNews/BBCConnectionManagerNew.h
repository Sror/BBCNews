//
//  BBCConnectionManagerNew.h
//  BBCNews
//
//  Created by Sergey Shulga on 7/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCConnectionManagerNew : NSObject

+ (BBCConnectionManagerNew *)manager;

- (void)cancelAllAperations;

- (void)getFeedsWithCallback:(void (^)(NSArray *feeds, NSError *error))callback;

- (void)getImageDataForUrl:(NSURL *)url callBack:(void(^)(NSData *imageData, NSError *error))callback;

@end
