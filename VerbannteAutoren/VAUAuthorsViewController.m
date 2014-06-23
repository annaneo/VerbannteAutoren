//
//  VAUAuthorsViewController.m
//  VerbannteAutoren
//
//  Created by Anna Neovesky on 20.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import "VAUAuthorsViewController.h"
#import "VAUAuthorDetailViewController.h"

@implementation VAUAuthorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _authorNames = [[NSMutableArray alloc] initWithCapacity:512];
    [self loadData];
    _authorsTable.delegate = self;
    _authorsTable.dataSource = self;
    [_authorsTable reloadData];
    
    
}


#pragma mark - Table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_authorNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"authorCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    // gets Array at row [firstName, lastName]
    NSArray* namesArray = [_authorNames objectAtIndex:row];
    // puts objects from Array into String
    NSString* namesString = [NSString stringWithFormat:@"%@ %@", [namesArray firstObject], [namesArray lastObject]];
    cell.textLabel.text = namesString;
    return cell;
}

#pragma mark - JSON Parsing

//  get load data from plist
- (void)loadData {
    /* load json
    NSString* path = [[NSBundle mainBundle] pathForResource:@"verbannte-buecher" ofType:@"json"];

    
    NSData* content = [[NSFileManager defaultManager] contentsAtPath:path];
    _data = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray* array = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableContainers error:nil];
    [self createDataDictionary:array];
     */
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    _data = [NSDictionary dictionaryWithContentsOfFile:path];
    [self sortAuthors];
}




// sorts Authors alphabetically by lastName
- (void)sortAuthors {
    NSMutableArray *authorNames = [NSMutableArray arrayWithCapacity:512];
    NSDictionary* tempDict;
    for (NSArray* entry in _data) {
        tempDict = [[_data objectForKey:entry] firstObject];
        [authorNames addObject:@[[tempDict objectForKey:@"authorFirstname"],
                                 [tempDict objectForKey:@"authorLastname"]]];
    }
    
    NSOrderedSet* authorSet = [NSOrderedSet orderedSetWithArray:authorNames];
    _authorNames = [NSMutableArray arrayWithArray:[authorSet sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSString* lastName1 = [obj1 lastObject];
        NSString* lastName2 = [obj2 lastObject];
        NSComparisonResult result = [lastName1 compare:lastName2];
        if (result == NSOrderedSame) {
            NSString* firstName1 = [obj1 firstObject];
            NSString* firstName2 = [obj2 firstObject];
            return [firstName1 compare:firstName2];
        }
        return result;
    }]];
}


#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"authorDetailSegue"]) {
        VAUAuthorDetailViewController* detailViewController = [segue destinationViewController];
        detailViewController.works = [_data objectForKey:[(UITableViewCell*)sender textLabel].text];
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
