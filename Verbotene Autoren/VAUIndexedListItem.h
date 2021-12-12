//
//  VAUIndexedListItem.h
//  VerbannteAutoren
//
//  Created by Julius on 01/07/14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VAUIndexedListItem : NSObject

@property(nonatomic,copy) NSString *prename;
@property(nonatomic,copy) NSString *surname;
@property(nonatomic,copy) NSString *fullname;
@property(nonatomic,copy) NSString *sortingName;
@property NSInteger sectionNumber;

@end
