//
//  BBCFeedViewCell+FeedItem.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCFeedViewCell+FeedItem.h"
#import "BBCImageView.h"

@implementation BBCFeedViewCell (FeedItem)

- (void)configWithFeedItem:(BBCFeedItem *)feedItem{
    self.feedTitleLable.text = feedItem.title;
    self.descriptionLabel.text = feedItem.feedDescription;
    self.timeLabel.text = [[feedItem.class dateFormater] stringFromDate:feedItem.pubDate];
    
    NSData *imageData = feedItem.smallImageData;
    
    if (imageData) {
        self.feedImageView.image = [UIImage imageWithData:feedItem.smallImageData];
    } else {
        NSURL *url = [NSURL URLWithString:feedItem.thumbnailSmall];
        [self.feedImageView setImageWithUrl:url];
    }
    
}

@end
