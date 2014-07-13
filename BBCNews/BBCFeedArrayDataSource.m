//
//  BBCFeedArrayDataSource.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCFeedArrayDataSource.h"

@interface BBCFeedArrayDataSource ()

@property (retain, nonatomic) NSArray  *items;
@property (copy, nonatomic)   NSString *cellId;
@property (copy, nonatomic)   void(^cellConfigureBlock)(UITableViewCell *cell, id item);

@end

@implementation BBCFeedArrayDataSource

- (id)initWithItems:(NSArray *)items cellId:(NSString *)cellId cellConfigureBlock:(void (^)(UITableViewCell *, id item))cellConfigureBlock{
    
    self = [super init];
    
    if (self) {
        _items = [items retain];
        _cellId = [cellId copy];
        self.cellConfigureBlock = cellConfigureBlock;
    }
    
    return self;
}

- (BBCFeedItem *)feedItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.items[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    BBCFeedItem* item = [self feedItemAtIndexPath:indexPath];
    self.cellConfigureBlock(cell, item);
    
    return cell;
}

@end
