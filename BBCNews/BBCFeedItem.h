//
//  BBCFeedItem.h
//  BBCNews
//
//  Created by Sergey Shulga on 7/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BBCFeedItem : NSManagedObject

@property (nonatomic, retain) NSString * feedDescription;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * thumbnailBig;
@property (nonatomic, retain) NSString * thumbnailSmall;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * smallImageData;
@property (nonatomic, retain) NSData * bigImageData;

@end
