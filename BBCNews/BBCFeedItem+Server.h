//
//  BBCFeedItem+Server.h
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCFeedItem.h"

@interface BBCFeedItem (Server)

+ (BBCFeedItem *)createOreUpdateWithProperties:(NSDictionary *)properties;

+ (NSDateFormatter *)dateFormater;

+ (NSArray *)feedsFromLastDay;

+ (void)getFeedsWithCallback:(void(^)(NSArray *feeds, NSError* error))callback;

@end