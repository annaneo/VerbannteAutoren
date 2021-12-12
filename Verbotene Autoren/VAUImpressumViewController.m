//
//  VAUImpressumViewController.m
//  VerbannteAutoren
//
//  Created by anna on 03.07.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import "VAUImpressumViewController.h"

@interface VAUImpressumViewController ()

@end

@implementation VAUImpressumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // load WebView
    
    NSURL* fileURL = [[NSBundle mainBundle] URLForResource: @"impressum" withExtension:@"html"];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:fileURL];
    [_webView loadRequest:urlRequest];

    [_webView setNavigationDelegate:self];
    
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
