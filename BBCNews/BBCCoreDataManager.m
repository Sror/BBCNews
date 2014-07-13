//
//  BBCCoreDataManager.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCCoreDataManager.h"

@interface BBCCoreDataManager () {
    
    NSManagedObjectContext        *_managedObjectContext;
    NSManagedObjectModel          *_managedObjectModel;
    NSPersistentStoreCoordinator  *_persistentStoreCoordinator;
    NSDateFormatter               *_dateFormater;
}

@end

@implementation BBCCoreDataManager

+ (BBCCoreDataManager *)manager{
    
    static BBCCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BBCCoreDataManager alloc] init];
        manager->_dateFormater = [[NSDateFormatter alloc] init];
        [manager->_dateFormater setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
    });
    
    return manager;
}

- (NSDateFormatter *)dateFormater{
    return _dateFormater;
}

- (NSManagedObject *)newEntityForEntityName:(NSString *)name{
    
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];;
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    return newManagedObject;
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

#pragma mark - Private

- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSManagedObjectModel *)managedObjectModel{
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BBCNews" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}


@end
