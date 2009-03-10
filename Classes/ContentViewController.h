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
	// IBOutlet UIWebView *webView;
	IBOutlet UILabel *headline;
	IBOutlet UILabel *byline;
	IBOutlet UILabel *body;
	IBOutlet UIScrollView *scrollView;
	GuardianContent *content;
}

- (void)tagButtonWasPressed:(id)sender;

@property (nonatomic,retain) GuardianContent *content;
@property (nonatomic,retain) UILabel *headline;
@property (nonatomic,retain) UILabel *byline;
@property (nonatomic,retain) UILabel *body;
@property (nonatomic,retain) UIScrollView *scrollView;

@end
