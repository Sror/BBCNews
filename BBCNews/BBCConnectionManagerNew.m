//
//  BBCConnectionManagerNew.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCConnectionManagerNew.h"
#import "BBCXMLParserOperation.h"

@interface BBCConnectionManagerNew ()

@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, copy)   void (^callback)(NSData *data, NSError *error);

@end

@implementation BBCConnectionManagerNew

+ (BBCConnectionManagerNew *)manager{
    static BBCConnectionManagerNew *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[BBCConnectionManagerNew alloc] init];
        _manager.queue = [[NSOperationQueue alloc] init];
    });
    
    return _manager;
}

#pragma mark - Public

- (void)getFeedsWithCallback:(void (^)(NSArray *, NSError *))callback{
    
    NSURL *url = [NSURL URLWithString:@"http://feeds.bbci.co.uk/news/rss.xml"];
    [self _getDataFromUrl:url withCallback:^(NSData *data, NSError *error) {
        if (error) {
            callback(nil, error);
        } else {
            [self _parseXMLData:data withCallback:callback];
        }

    }];
    
}

- (void)getImageDataForUrl:(NSURL *)url callBack:(void (^)(NSData *, NSError *))callback{
    [self _getDataFromUrl:url withCallback:callback];
}

- (void)cancelAllAperations{
    [self.queue cancelAllOperations];
}

#pragma mark - Private

- (void)_getDataFromUrl:(NSURL *)url withCallback:(void (^)(NSData *, NSError *))callback{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(data, connectionError);
        });
    }];
}

- (void)_parseXMLData:(NSData *)data withCallback:(void (^)(NSArray *array, NSError *error))callback{
    BBCXMLParserOperation *parsOperation = [[BBCXMLParserOperation alloc] initWithDataToParse:data complationBlock:^(NSArray *parsedEnties) {
        if ([parsedEnties count] > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(parsedEnties, nil);
            });
        }

    }];
    [self.queue addOperation:parsOperation];
    [parsOperation release];
}

@end
