//
//  VAUImpressumViewController.h
//  VerbannteAutoren
//
//  Created by anna on 03.07.14.
//  Copyright (c) 2014 Mr Fridge Software & Digitale Akademie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebKit/WebKit.h"

@interface VAUImpressumViewController : UIViewController <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end
