//
//  BBCFeedViewCell.h
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBCImageView;

@interface BBCFeedViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet BBCImageView *feedImageView;
@property (retain, nonatomic) IBOutlet UILabel      *feedTitleLable;
@property (retain, nonatomic) IBOutlet UILabel      *descriptionLabel;
@property (retain, nonatomic) IBOutlet UILabel      *timeLabel;

@end
