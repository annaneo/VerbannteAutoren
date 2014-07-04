//
//  VAUAuthorDetailViewController.h
//  VerbannteAutoren
//
//  Created by anna on 21.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VAUDetailTableViewCell;

@interface VAUAuthorDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    VAUDetailTableViewCell *_prototypecell;
}

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic) NSString* biography;
@property (nonatomic) UIImage* image;
@property (nonatomic) NSArray* worksDataArray;
@property (nonatomic) NSString* worksString;
@property (nonatomic) NSString* wikiLink;
@property (nonatomic) NSString* gndLink;

@end
