//
//  VAUAuthorDetailViewController.h
//  VerbannteAutoren
//
//  Created by anna on 21.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VAUAuthorDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic) NSString* biography;
@property (nonatomic) UIImage* image;
@property (nonatomic) NSArray* works;
@property (nonatomic) NSString* wikiLink;
@property (nonatomic) NSString* gndLink;

@end
