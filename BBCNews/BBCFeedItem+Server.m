//
//  BBCFeedItem+Server.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCFeedItem+Server.h"
#import "BBCConnectionManagerNew.h"

#define kBBCFeedItemParamPubDate        @"pubDate"
#define kBBCFeedItemParamThumbnailSmall @"thumbnail_small"
#define kBBCFeedItemParamThumbnailBig   @"thumbnail_big"
#define kBBCFeedItemParamDescription    @"description"

@implementation BBCFeedItem (Server)

+ (BBCFeedItem *)createOreUpdateWithProperties:(NSDictionary *)properties{
    
    NSDate *date = [[[BBCCoreDataManager manager] dateFormater] dateFromString:properties[@"pubDate"]];
    
    BBCFeedItem *feedItem = [BBCFeedItem findFirstByAtribute:kBBCFeedItemParamPubDate value:date];
    
    if (feedItem == nil) {
        feedItem = (BBCFeedItem *)[[BBCCoreDataManager manager] newEntityForEntityName:@"BBCFeedItem"];
    }
    
    [feedItem updateWithProperties:properties];
    
    [[[BBCCoreDataManager manager] managedObjectContext] save:nil];
    
    return feedItem;
}

+ (NSDateFormatter *)dateFormater{
    static NSDateFormatter *_dateFormater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormater = [[NSDateFormatter alloc] init];
        [_dateFormater setDateFormat:@"MM/dd hh:mm a"];
    });
    
    return _dateFormater;
}

+ (void)getFeedsWithCallback:(void (^)(NSArray *, NSError *))callback{
    [[BBCConnectionManagerNew manager] getFeedsWithCallback:^(NSArray *parsedEnties, NSError *error) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *feedDict in parsedEnties) {
            BBCFeedItem *feedItem = [BBCFeedItem createOreUpdateWithProperties:feedDict];
            [array addObject:feedItem];
        }
        [array sortUsingComparator:^NSComparisonResult(BBCFeedItem *obj1, BBCFeedItem * obj2) {
            return [obj2.pubDate compare:obj1.pubDate];
        }];
        [[BBCCoreDataManager manager].managedObjectContext save:nil];
        callback(array, error);
    }];
}

#pragma mark -

- (void)updateWithProperties:(NSDictionary *)properties{
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqualToString:kBBCFeedItemParamPubDate]) {
            NSDate *date = [[[BBCCoreDataManager manager] dateFormater] dateFromString:obj];
            [self setValue:date forKey:key];
        } else if ([key isEqualToString:kBBCFeedItemParamDescription]){
            [self setValue:obj forKey:@"feedDescription"];
        } else if ([key isEqualToString:kBBCFeedItemParamThumbnailSmall]){
            [self setValue:obj forKey:@"thumbnailSmall"];
        } else if ([key isEqualToString:kBBCFeedItemParamThumbnailBig]){
            [self setValue:obj forKey:@"thumbnailBig"];
        }
        else {
            [self setValue:obj forKey:key];
        }
    }];
}

#pragma mark - Fetch methods

+ (BBCFeedItem *)findFirstByAtribute:(NSString *)atribute value:(id)value{
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] initWithEntityName:@""] autorelease];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", atribute, value];
    NSManagedObjectContext *moc = [[BBCCoreDataManager manager] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[self description] inManagedObjectContext:moc];
    
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:atribute ascending:YES] autorelease];
    
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    
    return array.count > 0 ? array[0] : nil;
}

+ (NSArray *)feedsFromLastDay{
    NSManagedObjectContext *moc = [[BBCCoreDataManager manager] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"BBCFeedItem" inManagedObjectContext:moc];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSDate *minimumDate = [NSDate dateWithTimeInterval:-24 * 3600 sinceDate:[NSDate date]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"pubDate > %@", minimumDate];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO] autorelease];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    return array;
}

@end
