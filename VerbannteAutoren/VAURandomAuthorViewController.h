//
//  VAURandomAuthorViewController.h
//  VerbannteAutoren
//
//  Created by Julius on 04/07/14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VAURandomTableViewCell;

@interface VAURandomAuthorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    VAURandomTableViewCell *_prototypecell;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;

@property (nonatomic) NSString* biography;
@property (nonatomic) UIImage* image;
@property (nonatomic) NSArray* worksDataArray;
@property (nonatomic) NSString* worksString;
@property (nonatomic) NSString* wikiLink;
@property (nonatomic) NSString* gndLink;

@end
