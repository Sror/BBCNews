//
//  BBCFeedViewCell+FeedItem.h
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCFeedViewCell.h"

@class BBCFeedItem;

@interface BBCFeedViewCell (FeedItem)

- (void) configWithFeedItem:(BBCFeedItem *)feedItem;

@end