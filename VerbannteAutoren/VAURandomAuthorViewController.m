//
//  VAURandomAuthorViewController.m
//  VerbannteAutoren
//
//  Created by Julius on 04/07/14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import "VAURandomAuthorViewController.h"
#import "VAUAppDelegate.h"
#include <stdlib.h>
#import "VAUIndexedListItem.h"
#import "VAURandomTableViewCell.h"


@interface VAURandomAuthorViewController ()

@property (nonatomic) NSArray* indexedListFull;

@end

@implementation VAURandomAuthorViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _prototypecell = [self.table dequeueReusableCellWithIdentifier:@"RandomCell"];
    _biography = @"";
    _image = nil;
    _worksString = @"";
    _wikiLink = @"";
    _gndLink = @"";
    _indexedListFull = [[NSArray arrayWithArray:[(VAUAppDelegate*)[UIApplication sharedApplication].delegate indexedList]] mutableCopy];
    [self generateRandomAuthor];

    [self generateWorks];
    [self fetchAddtionalData];
    _table.delegate = self;
    _table.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    _biography = @"";
    _image = nil;
    _worksString = @"";
    _wikiLink = @"";
    _gndLink = @"";

    [self generateRandomAuthor];

    [self generateWorks];
    [self fetchAddtionalData];
    [_table reloadData];

}

- (void)generateRandomAuthor {
    NSInteger randomInitial = arc4random_uniform((u_int32_t)[_indexedListFull count] - 1);
    NSArray* authors = _indexedListFull[randomInitial];
    while (authors.count == 0) {
        randomInitial = arc4random_uniform((u_int32_t)[_indexedListFull count] - 1);
        authors = _indexedListFull[randomInitial];
    }
    NSInteger randomAuthor = arc4random_uniform((u_int32_t)[authors count] - 1);
    VAUIndexedListItem* authorItem = authors[randomAuthor];
    _worksDataArray = [[(VAUAppDelegate*)[UIApplication sharedApplication].delegate rawData] objectForKey:authorItem.fullname];
    _titleLabel.text = authorItem.fullname;
    NSLog(@"Random Autor: %@", _titleLabel.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchAddtionalData {
    [self fetchDataFromWikipedia];
    _wikiLink = [self generateWikipediaLink];
}


// set all forbidden works
- (void)generateWorks {
    NSMutableString* singleWork;
    for (NSDictionary* item in _worksDataArray) {
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
        if (![singleWork isEqualToString:[_worksDataArray lastObject]]) {
            [singleWork appendString:@"\n\n"];
        }
        _worksString = [_worksString stringByAppendingString:singleWork];
    }
}


- (void)fetchDataFromWikipedia {
    NSString* baseUrl = @"http://de.wikipedia.org/w/api.php?";
    NSString* properties = @"format=json&action=query&prop=revisions&indexpageids&rvprop=content&rvparse&redirects";
    NSString* title = _titleLabel.text;
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
    // find stuff like http://d-nb.info/gnd/118781278

    NSRegularExpression* gndRegex = [NSRegularExpression regularExpressionWithPattern:@"\\http://d-nb.info/gnd/([0-9]+)" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"GND Error: %@", [[error userInfo] objectForKey:@"NSInvalidValue"]);
    }
    NSRange rangeOfFirstMatch = [gndRegex rangeOfFirstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        _gndLink = [content substringWithRange:rangeOfFirstMatch];
        NSLog(@"first match gnd: %@", _gndLink);
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
        _image = [UIImage imageWithData:imageData];
    } else {
        _image = nil;
    }

    // getting first section
    _biography = [self fetchBiography];

}

- (NSString*)fetchBiography {
    NSString* baseUrl = @"http://de.wikipedia.org/w/api.php?";
    NSString* properties = @"format=json&action=query&prop=revisions&rvsection=0&indexpageids&rvprop=content&rvparse&redirects";
    NSString* title = _titleLabel.text;
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
    //TODO: remove divs and tables
    r = [content rangeOfString:@"div>" options:NSBackwardsSearch];
    if (!NSEqualRanges(r, NSMakeRange(NSNotFound, 0))) {
        content = [content substringFromIndex:r.location + r.length];
    }

    // remove leading \n
    while ([content hasPrefix:@"\n"]) {
        content = [content substringFromIndex:1];
    }

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

- (NSString*)generateWikipediaLink {
    if (_biography.length == 0) {
        return nil;
    }
    NSString* title = _titleLabel.text;
    NSString* urlString = [NSString stringWithFormat:@"http://de.wikipedia.org/wiki/%@", title];
    return [urlString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
}


#pragma mark - TableViewDelegat/TableViewSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAURandomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RandomCell"];
    [cell reset];
    NSInteger row = indexPath.row;
    [self configureCell:cell forRow:row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3:
            if (_wikiLink.length > 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_wikiLink]];
            }
            break;
        case 4:
            if (_gndLink.length > 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_gndLink]];
            }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:_prototypecell forRow:indexPath.row];
    [_prototypecell layoutIfNeeded];
    CGSize size = [_prototypecell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)configureCell:(VAURandomTableViewCell*)cell forRow:(NSInteger)row {
    cell.image.hidden = YES;
    cell.title.hidden = NO;
    cell.title.text = @"";
    cell.content.hidden = NO;
    cell.content.text = @"";
    cell.image.image = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.content.textColor = [UIColor blackColor];
    switch (row) {
        case 0:
            if (_biography.length > 0) {
                cell.title.text = @"Biographie";
                cell.content.text = _biography;
            }
            break;
        case 1:
            cell.title.hidden = YES;
            cell.content.hidden = YES;
            if (_image) {
                cell.image.hidden = NO;
                cell.image.image = _image;
            }
            break;
        case 2:
            if (_worksString.length > 0) {
                cell.title.text = @"Verbannte Werke";
                cell.content.text = _worksString;
            }
            break;
        case 3:
            if (_wikiLink.length > 0) {
                cell.title.text = @"Wikipedia";
                cell.content.text = _wikiLink;
                cell.content.textColor = [UIColor blueColor];
            }
            break;
        case 4:
            if (_gndLink.length > 0) {
                cell.title.text = @"GND";
                cell.content.text = _gndLink;
                cell.content.textColor = [UIColor blueColor];
            }
            break;

        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
