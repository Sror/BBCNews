//
//  BBCImageView.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCImageView.h"
#import "BBCConnectionManagerNew.h"
#import "BBCImageCash.h"

@interface BBCImageView () <NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSMutableData   *receivedData;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSURL           *url;
@property (nonatomic, retain) UIImage         *placeholderImage;

@end

@implementation BBCImageView

- (void)dealloc{
    [self.receivedData release];
    [self.connection release];
    [self.url release];
    [self.placeholderImage release];
    
    [super dealloc];
}

#pragma mark - Public

- (void) setImageWithUrl:(NSURL *)url{
    self.url = url;
    [self _setImageFromCashOrStartConnection];
}

#pragma mark - Private

- (void) _setImageFromCashOrStartConnection{
    
    NSData *imageData = [[BBCImageCash imageCash] imageDataForKey:[self.url absoluteString]];
    
    if (imageData == nil){
        [self _startConnection];
    } else {
        self.image = [UIImage imageWithData:imageData];
    }
}

- (void) _startConnection{
    [[BBCConnectionManagerNew manager] getImageDataForUrl:self.url callBack:^(NSData *imageData, NSError *error) {
        self.image = [UIImage imageWithData:imageData];
        if (imageData) {
            [[BBCImageCash imageCash] insertImageData:imageData forKey:[self.url absoluteString]];
        }
    }];
}

@end
