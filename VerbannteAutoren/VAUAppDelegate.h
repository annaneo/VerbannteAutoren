//
//  VAUAppDelegate.h
//  VerbannteAutoren
//
//  Created by anna on 20.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VAUAppDelegate : UIResponder <UIApplicationDelegate> {
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray* authorNames;
@property (strong, nonatomic) NSMutableDictionary* rawData;
@property (strong, nonatomic) NSMutableArray* indexedList;

@end
