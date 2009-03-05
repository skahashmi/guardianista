//
//  ContentViewController.h
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuardianContent.h"

@interface ContentViewController : UIViewController {
	IBOutlet UIWebView *webView;
	GuardianContent *content;
	NSString *url;
}

- (IBAction)tagButtonWasPressed;

@property (nonatomic,retain) GuardianContent *content;

@end
