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
}

- (void)fetchDataFromWikipedia {
    //    NSString* baseUrl = @"http://de.wikipedia.org/w/api.php?";
    //    NSString* properties = @"format=json&action=query&prop=revisions&rvprop=content&rvsection=0&rvparse&redirects=true";
    //    NSString* title = self.navigationItem.title;
    
    //    NSString* urlString = [NSString stringWithFormat:@"%@%@&titles=%@", baseUrl, properties, title];
    //    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    //    NSURL* url = [NSURL URLWithString:urlString];
    //    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    //    [request setHTTPMethod:@"GET"];
    //    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //normally this would use the data recieved from wikipedia
    
    
    // getting gnd number
    NSError *error = NULL;
    
    NSString* file = [[NSBundle mainBundle] pathForResource:@"testWiki" ofType:@"json"];
    NSDictionary* wikiDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:file options:NSDataReadingUncached error:&error] options:NSJSONReadingMutableContainers error:&error];
    //weird stuff is happening here :)
    NSString* content = [[[wikiDict objectForKey:@"parse"] objectForKey:@"text"] objectForKey:@"*"];
    
    // find stuf like http://d-nb.info/gnd/118781278
    
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
        
        NSURL* url = [NSURL URLWithString:substringForFirstMatch];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"GET"];
        //TODO: does this work
        NSData* imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        UIImage* authorImage = [UIImage imageWithData:imageData];
        [_authorImageView setImage:authorImage];
    }
    
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
