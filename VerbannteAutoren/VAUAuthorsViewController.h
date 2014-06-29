//
//  VAUAuthorsViewController.h
//  VerbannteAutoren
//
//  Created by anna on 20.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VAUAuthorsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar* searchbar;
@property (weak, nonatomic) IBOutlet UITableView* authorsTable;
@property (strong, nonatomic) NSMutableArray* authorNames;
@property (strong, nonatomic) NSMutableDictionary* data;
@property (strong, nonatomic) NSMutableArray* tableData;


@end
