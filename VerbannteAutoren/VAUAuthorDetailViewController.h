//
//  VAUAuthorDetailViewController.h
//  VerbannteAutoren
//
//  Created by anna on 21.06.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VAUAuthorDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView* worksTextView;
@property (strong, nonatomic) NSArray* works;

@end
