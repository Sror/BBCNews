//
//  BBCViewController.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/9/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCFeedTableViewController.h"
#import "BBCFeedViewCell+FeedItem.h"
#import "BBCFeedArrayDataSource.h"
#import "BBCNewsDetailsViewController.h"
#import "BBCErrorHandler.h"
#import "BBCConnectionManagerNew.h"

@interface BBCFeedTableViewController ()

@property (nonatomic, retain) BBCFeedArrayDataSource *arrayDataSource;

@end

@implementation BBCFeedTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self _configureNavigationBar];
    [self _registrCells];
    [self _loadData];
}

- (void)dealloc{
    [self.arrayDataSource release];
    
    [super dealloc];
}

#pragma mark - Private

- (void) _configureNavigationBar{
    self.title = @"BBC News";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(_loadData)];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void) _preapearDataSourceForFeeds:(NSArray *)feeds{
    self.arrayDataSource = [[BBCFeedArrayDataSource alloc] initWithItems:feeds cellId:[BBCFeedViewCell description] cellConfigureBlock:^(UITableViewCell *cell, id item) {
        BBCFeedViewCell *feedCell = (BBCFeedViewCell *)cell;
        [feedCell configWithFeedItem:item];
    }];
    self.tableView.dataSource = self.arrayDataSource;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) _loadData{
    [BBCFeedItem getFeedsWithCallback:^(NSArray *feeds, NSError *error) {
        if (error) {
            [BBCErrorHandler handleError:error];
            [self _preapearDataSourceForFeeds:[BBCFeedItem feedsFromLastDay]];
        } else {
            [self _preapearDataSourceForFeeds:feeds];
        }
    }];
}

- (void) _registrCells{
    [self.tableView registerNib:[UINib nibWithNibName:[BBCFeedViewCell description] bundle:nil] forCellReuseIdentifier:[BBCFeedViewCell description]];
}

- (void) _loadImageDataForFeedItemIfShould:(BBCFeedItem *)feedItem{
    if (feedItem.smallImageData == nil) {
        NSURL* url = [NSURL URLWithString:feedItem.thumbnailSmall];
        
        [[BBCConnectionManagerNew manager] getImageDataForUrl:url callBack:^(NSData *imageData, NSError *error) {
            if (!error) {
                feedItem.smallImageData = imageData;
            }
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BBCFeedItem *feedItem = [[self.arrayDataSource feedItemAtIndexPath:indexPath] retain];
    
    BBCNewsDetailsViewController *newsDetailsViewController = [[BBCNewsDetailsViewController alloc] initWithNibName:nil bundle:nil feeditem:feedItem];
    
    [self.navigationController pushViewController:newsDetailsViewController animated:YES];
    
    [newsDetailsViewController release];
    [feedItem release];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    BBCFeedItem *feedItem = [[self.arrayDataSource feedItemAtIndexPath:indexPath] retain];
    
    [self _loadImageDataForFeedItemIfShould:feedItem];
    
    [feedItem release];
}

@end
