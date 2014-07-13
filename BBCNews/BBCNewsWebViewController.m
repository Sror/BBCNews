//
//  BBCNewsWebViewController.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/12/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCNewsWebViewController.h"

@interface BBCNewsWebViewController ()

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) NSURL *url;

@end

@implementation BBCNewsWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil link:(NSString *)link{
    self = [super init];
    if (self) {
        _url = [[NSURL alloc] initWithString:link];
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}


- (void)dealloc{ 
    [self.webView release];
    [self.url release];
    
    [super dealloc];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
