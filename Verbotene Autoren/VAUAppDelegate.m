//
//  VAUAppDelegate.m
//  VerbannteAutoren
//
//  Created by anna on 20.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import "VAUAppDelegate.h"
#import "VAUIndexedListItem.h"
#import "LRIndexedCollationWithSearch.h"

@implementation VAUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _authorNames = [NSMutableArray arrayWithCapacity:1];
    _indexedList = [NSMutableArray arrayWithCapacity:1];
    [self loadData];
    self.window.tintColor = [UIColor colorWithRed:0.79 green:0.25 blue:0 alpha:1]; //or whatever color you want
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Preparing Data

- (void)loadData {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    _rawData = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [self sortAuthors:_rawData];
}

// sorts Authors alphabetically by lastName
- (void)sortAuthors:(NSDictionary*)authorsDict {
    NSMutableArray *authorNames = [NSMutableArray arrayWithCapacity:512];
    NSDictionary* tempDict;
    for (NSArray* entry in authorsDict) {
        tempDict = [[authorsDict objectForKey:entry] firstObject];
        [authorNames addObject:@[[tempDict objectForKey:@"authorFirstname"],
                                 [tempDict objectForKey:@"authorLastname"]]];
    }

    NSMutableArray* tempItems = [NSMutableArray arrayWithCapacity:1];

    for (NSArray* entry in authorNames) {
        VAUIndexedListItem* tempItem = [[VAUIndexedListItem alloc] init];
        tempItem.prename = [entry firstObject];
        tempItem.surname = [entry lastObject];
        tempItem.fullname = [[NSString stringWithFormat:@"%@ %@", [entry firstObject], [entry lastObject]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        tempItem.sortingName = [[NSString stringWithFormat:@"%@ %@", [entry lastObject], [entry firstObject]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [tempItems addObject:tempItem];
    }

    LRIndexedCollationWithSearch *theCollation = [LRIndexedCollationWithSearch currentCollation];

    for (VAUIndexedListItem *item in tempItems) {
        NSInteger sect = [theCollation sectionForObject:item collationStringSelector:@selector(surname)];
        item.sectionNumber = sect;
    }

    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }

    for (VAUIndexedListItem *item in tempItems) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:item.sectionNumber] addObject:item];
    }

    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(sortingName)];
        [self.indexedList addObject:sortedSection];
    }


/*

    NSOrderedSet* authorSet = [NSOrderedSet orderedSetWithArray:authorNames];
    NSMutableArray* sortedNames = [NSMutableArray arrayWithArray:[authorSet sortedArrayUsingComparator:^(id obj1, id obj2) {
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
    _authorNames = [NSMutableArray arrayWithCapacity:4096];
    for (NSArray* names in sortedNames) {
        NSString* namesString = [NSString stringWithFormat:@"%@ %@", [names firstObject], [names lastObject]];
        namesString = [namesString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [_authorNames addObject:namesString];
    }
*/
}

@end
