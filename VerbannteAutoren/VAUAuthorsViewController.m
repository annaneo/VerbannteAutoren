//
//  VAUAuthorsViewController.m
//  VerbannteAutoren
//
//  Created by Anna Neovesky on 20.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import "VAUAuthorsViewController.h"
#import "VAUAuthorDetailViewController.h"
#import "VAUAppDelegate.h"
#import "VAUIndexedListItem.h"
#import "LRIndexedCollationWithSearch.h"

@implementation VAUAuthorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //_authorNames = [NSMutableArray arrayWithArray:[(VAUAppDelegate*)[UIApplication sharedApplication].delegate authorNames]];
    _indexedList = [NSMutableArray arrayWithArray:[(VAUAppDelegate*)[UIApplication sharedApplication].delegate indexedList]];
    //_tableData = [_authorNames mutableCopy];
    _authorsTable.delegate = self;
    _authorsTable.dataSource = self;
    [_authorsTable reloadData];
    _searchbar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [_authorsTable setContentOffset:CGPointMake(0, 44)];
}


#pragma mark - Table Delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[LRIndexedCollationWithSearch currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.indexedList objectAtIndex:section] count] > 0) {
        return [[[LRIndexedCollationWithSearch currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger section = [[LRIndexedCollationWithSearch currentCollation] sectionForSectionIndexTitleAtIndex:index];
    if(section == NSNotFound) {
        [tableView setContentOffset:CGPointMake(0,0)];
    }
    return section;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.indexedList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.indexedList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AuthorCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    VAUIndexedListItem* item = [[self.indexedList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = item.fullname;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchbar resignFirstResponder];
}

#pragma mark - JSON Parsing

////  get load data from plist
//- (void)loadData {
//    /* load json
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"verbannte-buecher" ofType:@"json"];
//    
//    NSData* content = [[NSFileManager defaultManager] contentsAtPath:path];
//    _data = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableContainers error:nil];
//    NSMutableArray* array = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableContainers error:nil];
//    [self createDataDictionary:array];
//     */
////     NSString* path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
//    //_data = [NSDictionary dictionaryWithContentsOfFile:path];
//    [self sortAuthors];
//    // table Data contains all author names
//    _tableData = [NSMutableArray arrayWithArray:_authorNames];
//}

// sorts Authors alphabetically by lastName
//- (void)sortAuthors {
//    NSMutableArray *authorNames = [NSMutableArray arrayWithCapacity:512];
////    NSDictionary* tempDict;
////    for (NSArray* entry in _data) {
////        tempDict = [[_data objectForKey:entry] firstObject];
////        [authorNames addObject:@[[tempDict objectForKey:@"authorFirstname"],
////                                 [tempDict objectForKey:@"authorLastname"]]];
////    }
//
//    NSOrderedSet* authorSet = [NSOrderedSet orderedSetWithArray:authorNames];
//    NSMutableArray* sortedNames = [NSMutableArray arrayWithArray:[authorSet sortedArrayUsingComparator:^(id obj1, id obj2) {
//        NSString* lastName1 = [obj1 lastObject];
//        NSString* lastName2 = [obj2 lastObject];
//        NSComparisonResult result = [lastName1 compare:lastName2];
//        if (result == NSOrderedSame) {
//            NSString* firstName1 = [obj1 firstObject];
//            NSString* firstName2 = [obj2 firstObject];
//            return [firstName1 compare:firstName2];
//        }
//        return result;
//    }]];
//    _authorNames = [NSMutableArray arrayWithCapacity:4096];
//    for (NSArray* names in sortedNames) {
//        NSString* namesString = [NSString stringWithFormat:@"%@ %@", [names firstObject], [names lastObject]];
//        namesString = [namesString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        [_authorNames addObject:namesString];
//    }
//    
//}


#pragma mark Search Bar Delegate

// searchbar & search
- (void)searchBar:(UISearchBar* )searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        _tableData = [NSMutableArray arrayWithArray:_authorNames];
    }
    else {
        [_tableData removeAllObjects];
        for (NSString* authorName in _authorNames) {
            // if searchterm is substring of authorname => insert into dataList
            if (!NSEqualRanges([[authorName lowercaseString] rangeOfString:[searchText lowercaseString]], NSMakeRange(NSNotFound, 0))){
                [_tableData addObject:authorName];
            }
        }
    }
    [_authorsTable reloadData];
}

// cancel button
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self searchBar:searchBar textDidChange:@""];
    [searchBar resignFirstResponder];
}


- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"authorDetailSegue"]) {
        VAUAuthorDetailViewController* detailViewController = [segue destinationViewController];
        NSString* name = [(UITableViewCell*)sender textLabel].text;
        NSArray* works = [[(VAUAppDelegate*)[UIApplication sharedApplication].delegate rawData] objectForKey:name];
        detailViewController.works = works;
        detailViewController.navigationItem.title = [(UITableViewCell*)sender textLabel].text;
    }
}



#pragma mark Helper

/*
 
 // create dictionary; used for initial data parsing
 // key: author firstname lastname Array
 // for key: all works from specific author in Dictionary Array
 -(void)createDataDictionary:(NSArray*)json {
 _data = [NSMutableDictionary dictionaryWithCapacity:1000];
 NSString* key;
 for (NSDictionary* entry in json) {
 
 NSMutableDictionary* myEntry = [NSMutableDictionary dictionary];
 [myEntry setObject:[entry objectForKey:@"title"] forKey:@"title"];
 [myEntry setObject:[entry objectForKey:@"firstEditionPublicationYear"] forKey:@"firstEditionPublicationYear"];
 [myEntry setObject:[entry objectForKey:@"firstEditionPublicationPlace"] forKey:@"firstEditionPublicationPlace"];
 [myEntry setObject:[entry objectForKey:@"firstEditionPublisher"] forKey:@"firstEditionPublisher"];
 
 NSString* firstName = [[entry objectForKey:@"authorFirstname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 NSString* lastName = [[entry objectForKey:@"authorLastname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
 if (firstName.length == 0 && lastName.length == 0) {
 lastName = @"Unbekannter Autor";
 }
 
 [myEntry setObject:firstName forKey:@"authorFirstname"];
 [myEntry setObject:lastName forKey:@"authorLastname"];
 
 
 // create key
 
 key = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
 key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
 // if author is unknown, save under key "Unbekannter Autor"
 
 NSMutableArray* works;
 // check if key is already existing
 if ([_data objectForKey:key] == nil) {
 works = [NSMutableArray arrayWithObject:myEntry];
 } else {
 works = [_data objectForKey:key];
 [works addObject:myEntry];
 }
 [_data setObject:works forKey:key];
 }
 
 
 NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString* docDirectory = [path firstObject];
 NSString* filename = [NSString stringWithFormat:@"%@/data.plist", docDirectory];
 
 [_data writeToFile:filename atomically:YES];
 
 }
 */

@end
