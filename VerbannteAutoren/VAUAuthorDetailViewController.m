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
//    _worksTextView.frame = [self contentSizeRectForTextView:_worksTextView];
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
    /*
    NSMutableString* singleWork;
    for (NSDictionary* item in _works) {
        NSString* title = [item objectForKey:@"title"];
        NSString* firstEditionPublicationPlace = [item objectForKey:@"firstEditionPublicationPlace"];
        NSString* firstEditionPublicationYear = [item objectForKey:@"firstEditionPublicationYear"];
        NSString* firstEditionPublisher = [item objectForKey:@"firstEditionPublisher"];
        singleWork = [NSMutableString stringWithFormat:@"%@", title];
        // if other information than title is given
        if (firstEditionPublicationPlace.length > 0) {
            [singleWork appendString:[NSString stringWithFormat:@", %@", firstEditionPublicationPlace]];
        }
        if (firstEditionPublicationYear.length > 0){
            [singleWork appendString:[NSString stringWithFormat:@" %@", firstEditionPublicationYear]];
        }
        if(firstEditionPublisher.length > 0) {
            [singleWork appendString:[NSString stringWithFormat:@" (Verlag: %@)", firstEditionPublisher]];
        }
        //break after each publication
        [singleWork appendString:@"\n\n"];
        //print text
        _worksTextView.text = [_worksTextView.text stringByAppendingString:singleWork];
    }
     */
}

- (void)fetchDataFromWikipedia {
    NSString* baseUrl = @"http://de.wikipedia.org/w/api.php?";
    NSString* properties = @"format=json&action=query&prop=revisions&indexpageids&rvprop=content&rvparse&redirects";
    NSString* title = self.navigationItem.title;
    NSError *error = NULL;

    NSString* urlString = [NSString stringWithFormat:@"%@%@&titles=%@", baseUrl, properties, title];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSURL* url = [NSURL URLWithString:urlString];
    if (url == nil) {
        return;
    }
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* wikiDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    NSDictionary* queryDict = [wikiDict objectForKey:@"query"];
    NSArray* pageIds = [queryDict objectForKey:@"pageids"];
    NSString* pageId = [pageIds firstObject];
    if (pageId == nil || pageId.integerValue < 0) {
        // if no page available, pageId is negative
        return;
    }
    NSDictionary* pagesDict = [queryDict objectForKey:@"pages"];
    NSDictionary* pageDict = [pagesDict objectForKey:pageId];
    NSArray* revisions = [pageDict objectForKey:@"revisions"];
    NSDictionary* contentDict = [revisions firstObject];
    if (contentDict == nil) {
        return;
    }
    NSString* content = [contentDict objectForKey:@"*"];
    // getting gnd number

    
//    NSString* file = [[NSBundle mainBundle] pathForResource:@"testWiki" ofType:@"json"];
//    NSDictionary* wikiDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:file options:NSDataReadingUncached error:&error] options:NSJSONReadingMutableContainers error:&error];

    //NSString* content = [[[wikiDict objectForKey:@"parse"] objectForKey:@"text"] objectForKey:@"*"];
    
    // find stuff like http://d-nb.info/gnd/118781278
    
    NSRegularExpression* gndRegex = [NSRegularExpression regularExpressionWithPattern:@"\\http://d-nb.info/gnd/([0-9]+)" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"GND Error: %@", [[error userInfo] objectForKey:@"NSInvalidValue"]);
    }
    NSRange rangeOfFirstMatch = [gndRegex rangeOfFirstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString* substringForFirstMatch = [content substringWithRange:rangeOfFirstMatch];
        NSLog(@"first match gnd: %@", substringForFirstMatch);
    }
    
    
    
    // getting image
    
    //stuff like: upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Artur_Mahraun%2C_1928.JPG/220px-Artur_Mahraun%2C_1928.JPG
    NSRegularExpression* imageRegex = [NSRegularExpression regularExpressionWithPattern:@"upload.wikimedia.org/wikipedia/commons/thumb/(\\S+)jpg/(\\S+)jpg" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Image Error: %@", [[error userInfo] objectForKey:@"NSInvalidValue"]);
    }
    rangeOfFirstMatch = [imageRegex rangeOfFirstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString* substringForFirstMatch = [content substringWithRange:rangeOfFirstMatch];
        NSLog(@"first match image: %@", substringForFirstMatch);
        if (![substringForFirstMatch hasPrefix:@"http://"]) {
            substringForFirstMatch = [NSString stringWithFormat:@"http://%@", substringForFirstMatch];
        }

        NSURL* imageUrl = [NSURL URLWithString:substringForFirstMatch];
        NSLog(@"%@", imageUrl);
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
        //TODO: does this work
        UIImage* authorImage = [UIImage imageWithData:imageData];
//        [_authorImageView setImage:authorImage];
//        _authorImageView.hidden = NO;
    } else {
//        _authorImageView.hidden = YES;
    }


    // getting first section
    [self fetchFirstSection];

    
}

- (NSString*)fetchFirstSection {

    NSString* baseUrl = @"http://de.wikipedia.org/w/api.php?";
    NSString* properties = @"format=json&action=query&prop=revisions&rvsection=0&indexpageids&rvprop=content&rvparse&redirects";
    NSString* title = self.navigationItem.title;
    NSError *error = NULL;

    NSString* urlString = [NSString stringWithFormat:@"%@%@&titles=%@", baseUrl, properties, title];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* wikiDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    NSDictionary* queryDict = [wikiDict objectForKey:@"query"];
    NSArray* pageIds = [queryDict objectForKey:@"pageids"];
    NSString* pageId = [pageIds firstObject];
    if (pageId == nil || pageId.integerValue < 0) {
        // if no page available, pageId is negative
        return nil;
    }
    NSDictionary* pagesDict = [queryDict objectForKey:@"pages"];
    NSDictionary* pageDict = [pagesDict objectForKey:pageId];
    NSArray* revisions = [pageDict objectForKey:@"revisions"];
    NSDictionary* contentDict = [revisions firstObject];
    if (contentDict == nil) {
        return nil;
    }
    NSString* content = [contentDict objectForKey:@"*"];
    NSRange brTagRange = [content rangeOfString:@"<br"];
    if (brTagRange.location != NSNotFound) {
        content = [content substringToIndex:[content rangeOfString:@"<br"].location];
    }
    NSRange r;
    // remove divs




    // remove html
    while ((r = [content rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:r withString:@""];
    }
    // remove numbers in brackets
    while ((r = [content rangeOfString:@"\\[.\\]" options:NSRegularExpressionSearch]).location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:r withString:@""];
    }

    NSLog(@"content: %@", content);
    return content;

}


#pragma mark - Helpers

- (CGRect)contentSizeRectForTextView:(UITextView *)textView {
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    CGRect textBounds = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    CGFloat width = (CGFloat)ceil(textBounds.size.width + textView.textContainerInset.left + textView.textContainerInset.right);
    CGFloat height = (CGFloat)ceil(textBounds.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom);
    return CGRectMake(0, 0, width, height);
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
