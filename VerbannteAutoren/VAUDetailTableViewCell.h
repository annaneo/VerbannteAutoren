//
//  VAUDetailTableViewCell.h
//  VerbannteAutoren
//
//  Created by Julius on 02/07/14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VAUDetailCellStyle) {
    VAUDetailCellStyleNone,
    VAUDetailCellStyleImage,
    VAUDetailCellStyleShortText,
    VAUDetailCellStyleLongText,
    VAUDetailCellStyleLink
};

@interface VAUDetailTableViewCell : UITableViewCell

@property (nonatomic) VAUDetailCellStyle cellStyle;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *image;

- (void)reset;

@end
