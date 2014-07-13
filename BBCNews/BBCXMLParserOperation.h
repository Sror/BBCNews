//
//  BBCXMLParserOperation.h
//  BBCNews
//
//  Created by Sergey Shulga on 7/9/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCXMLParserOperation : NSOperation

- (id)initWithDataToParse:(NSData *)data complationBlock:(void(^)(NSArray *parsedEnties))callback;

@end
