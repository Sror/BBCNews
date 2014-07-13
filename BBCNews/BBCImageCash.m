//
//  BBCImageCash.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCImageCash.h"

@interface BBCImageCash ()

@property (nonatomic, retain) dispatch_queue_t queue;
@property (nonatomic, retain) NSCache *cash;

@end

@implementation BBCImageCash

+ (BBCImageCash *)imageCash{
    static BBCImageCash *_imageCash = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCash = [[BBCImageCash alloc] init];
        _imageCash.queue = dispatch_queue_create("com.BBCNews.imagecashqueue", NULL);
    });
    
    return _imageCash;
}

- (void)insertImageData:(NSData *)imageData forKey:(NSString *)key{
    dispatch_sync(self.queue, ^{
        [self.cash setObject:imageData forKey:key];
    });
}

- (NSData *)imageDataForKey:(NSString *)key{
    return [self.cash objectForKey:key];
}

@end
