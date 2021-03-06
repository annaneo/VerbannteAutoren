//
//  VAUAuthorsViewController.h
//  VerbannteAutoren
//
//  Created by anna on 20.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VAUAuthorsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    BOOL _isSearchActive;

}

@property (weak, nonatomic) IBOutlet UISearchBar* searchbar;
@property (weak, nonatomic) IBOutlet UITableView* authorsTable;
@property (strong, nonatomic) NSMutableArray* authorNames;
@property (strong, nonatomic) NSMutableArray* tableData;
@property (strong, nonatomic) NSMutableArray* indexedList;
@property (strong, nonatomic) NSMutableArray* indexedListFull;
@property (nonatomic) CGFloat tableOffset;



@end
