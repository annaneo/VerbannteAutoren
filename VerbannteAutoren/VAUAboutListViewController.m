//
//  VAUAboutListViewController.m
//  VerbannteAutoren
//
//  Created by anna on 30.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import "VAUAboutListViewController.h"
#import "WebKit/WebKit.h"

@interface VAUAboutListViewController ()
@property (weak, nonatomic) IBOutlet WKWebView* contentWebView;

@end

@implementation VAUAboutListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // load WebView
    
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]];
//    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
//    [_contentWebView loadRequest:request];


    NSURL* fileURL = [[NSBundle mainBundle] URLForResource: @"about" withExtension:@"html"];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:fileURL];
    [_contentWebView loadRequest:urlRequest];

    [_contentWebView setNavigationDelegate:self];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ( [navigationAction navigationType] == WKNavigationTypeLinkActivated) {
        [[UIApplication sharedApplication] openURL: [[navigationAction request] URL] options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
