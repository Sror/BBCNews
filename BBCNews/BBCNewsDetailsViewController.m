//
//  BBCNewsDetailsViewController.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCNewsDetailsViewController.h"
#import "BBCNewsWebViewController.h"
#import "BBCConnectionManagerNew.h"
#import "BBCImageView.h"

@interface BBCNewsDetailsViewController ()

@property (retain, nonatomic) IBOutlet BBCImageView *newsImageView;
@property (retain, nonatomic) IBOutlet UILabel      *titleLabel;
@property (retain, nonatomic) IBOutlet UITextView   *descriptionTextView;
@property (retain, nonatomic)          BBCFeedItem  *feedItem;


@end

@implementation BBCNewsDetailsViewController

#pragma mark - Life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             feeditem:(BBCFeedItem *)feedItem{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _feedItem = [feedItem retain];
    }
    
    return self;
}

- (void)dealloc{
    [self.feedItem release];
    [self.newsImageView release];
    [self.titleLabel release];
    [self.descriptionTextView release];
    
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self _configNavigationBar];
    [self _configView];
}

#pragma mark - Private

- (void)_configNavigationBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"safari"] style:UIBarButtonItemStylePlain target:self action:@selector(viewInBrouserPressed:)];
    self.title = [[BBCFeedItem dateFormater] stringFromDate:self.feedItem.pubDate];
}

- (void)_configView{

    self.titleLabel.text = self.feedItem.title;
    self.descriptionTextView.text = self.feedItem.feedDescription;
    
    if (self.feedItem.bigImageData) {
        self.newsImageView.image = [UIImage imageWithData:self.feedItem.bigImageData];
    } else {
        [[BBCConnectionManagerNew manager] getImageDataForUrl:[NSURL URLWithString:self.feedItem.thumbnailSmall] callBack:^(NSData *imageData, NSError *error) {
            self.feedItem.bigImageData = imageData;
            self.newsImageView.image = [UIImage imageWithData:self.feedItem.bigImageData];
        }];
    }
    
}

- (void)_loadImageDataForFeedItemIfShould{
    if (self.feedItem.bigImageData == nil) {
        NSURL *url = [NSURL URLWithString:self.feedItem.thumbnailBig];
        [[BBCConnectionManagerNew manager] getImageDataForUrl:url callBack:^(NSData *imageData, NSError *error) {
            self.feedItem.bigImageData = imageData;
        }];
    }
}

#pragma mark - button Actions

- (void)viewInBrouserPressed:(id)sender {
    BBCNewsWebViewController *webViewController = [[BBCNewsWebViewController alloc] initWithNibName:nil bundle:nil link:self.feedItem.link];
    webViewController.title = self.feedItem.title;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    
    [webViewController release];
    [navigationController release];
}

@end
