//
//  BBCCoreDataManager.h
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

@interface BBCCoreDataManager : NSObject

+ (BBCCoreDataManager *)manager;

- (NSDateFormatter *)dateFormater;

- (NSManagedObjectContext *)managedObjectContext;

- (NSManagedObject *)newEntityForEntityName:(NSString *)name;

@end
