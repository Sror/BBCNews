//
//  BBCFeedArrayDataSource.h
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

@interface BBCFeedArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)items cellId:(NSString *)cellId cellConfigureBlock:(void(^)(UITableViewCell *cell, id item))cellConfigureBlock;

- (BBCFeedItem *)feedItemAtIndexPath:(NSIndexPath *)indexPath;

@end
