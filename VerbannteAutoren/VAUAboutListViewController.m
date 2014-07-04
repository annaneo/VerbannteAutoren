//
//  VAUAboutListViewController.m
//  VerbannteAutoren
//
//  Created by anna on 30.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import "VAUAboutListViewController.h"

@interface VAUAboutListViewController ()
@property (weak, nonatomic) IBOutlet UIWebView* contentWebView;

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
    
//    NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]];
    NSString* htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
//    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [_contentWebView loadHTMLString:htmlString baseURL:nil];

//    [_contentWebView loadRequest:request];
    
    [_contentWebView setDelegate:self];
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
