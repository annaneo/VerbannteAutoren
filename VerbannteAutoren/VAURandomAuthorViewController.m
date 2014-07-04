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
#include "VAUAuthorDetailViewController.h"
#include "VAUIndexedListItem.h"

@interface VAURandomAuthorViewController ()

@property (nonatomic) NSArray* indexedListFull;

@end

@implementation VAURandomAuthorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _indexedListFull = [[NSArray arrayWithArray:[(VAUAppDelegate*)[UIApplication sharedApplication].delegate indexedList]] mutableCopy];
    NSInteger randomInitial = arc4random_uniform([_indexedListFull count] - 1);
    NSArray* authors = _indexedListFull[randomInitial];
    NSInteger randomAuthor = arc4random_uniform([authors count] - 1);
    VAUAuthorDetailViewController* topView = (VAUAuthorDetailViewController*)[self topViewController];
    VAUIndexedListItem* authorItem = authors[randomAuthor];
    topView.title = authorItem.fullname;
    NSArray* works = [[(VAUAppDelegate*)[UIApplication sharedApplication].delegate rawData] objectForKey:authorItem.fullname];
    topView.worksDataArray = works;

}


- (void)viewWillAppear {
}

- (void)didReceiveMemoryWarning
{
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
