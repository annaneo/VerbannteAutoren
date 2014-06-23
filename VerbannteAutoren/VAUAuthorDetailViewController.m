//
//  VAUAuthorDetailViewController.m
//  VerbannteAutoren
//
//  Created by anna on 21.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import "VAUAuthorDetailViewController.h"

@interface VAUAuthorDetailViewController ()

@end

@implementation VAUAuthorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// loads all detail information
- (void)showDetails {
    [self showWorks];
    [self fetchDataFromWikipedia];
}

// set all forbidden works
- (void)showWorks {
    NSString* singleWork;
    for (NSDictionary* item in _works) {
        NSString* title = [item objectForKey:@"title"];
        NSString* firstEditionPublicationPlace = [item objectForKey:@"firstEditionPublicationPlace"];
        NSString* firstEditionPublicationYear = [item objectForKey:@"firstEditionPublicationYear"];
        NSString* firstEditionPublisher = [item objectForKey:@"firstEditionPublisher"];
        singleWork = [NSString stringWithFormat:@"%@\n%@, %@ (%@)\n", title, firstEditionPublicationPlace, firstEditionPublicationYear, firstEditionPublisher];
        _worksTextView.text = [_worksTextView.text stringByAppendingString:singleWork];
    }
}

- (void)fetchDataFromWikipedia {
    NSString* baseUrl = @"http://de.wikipedia.org/w/api.php?";
    NSString* properties = @"format=json&action=query&prop=revisions&rvprop=content&rvsection=0&rvparse&redirects=true";
    NSString* title = self.navigationItem.title;
    NSString* urlString = [NSString stringWithFormat:@"%@%@&titles=%@", baseUrl, properties, title];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
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
