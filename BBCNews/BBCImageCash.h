//
//  BBCImageCash.h
//  BBCNews
//
//  Created by Sergey Shulga on 7/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCImageCash : NSObject

+ (BBCImageCash *)imageCash;

- (void)insertImageData:(NSData *)imageData forKey:(NSString *)key;

- (NSData *)imageDataForKey:(NSString *)key;

@end
