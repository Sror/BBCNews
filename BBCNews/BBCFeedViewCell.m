//
//  BBCFeedViewCell.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCFeedViewCell.h"
#import "BBCImageView.h"

@implementation BBCFeedViewCell

- (void)prepareForReuse{
    [super prepareForReuse];
    self.feedImageView.image = nil;
}

- (void)dealloc{
    [self.feedImageView release];
    [self.feedTitleLable release];
    [self.descriptionLabel release];
    
    [super dealloc];
}

@end
