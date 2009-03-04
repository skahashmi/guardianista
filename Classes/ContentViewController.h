//
//  ContentViewController.h
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContentViewController : UIViewController {
	IBOutlet UIWebView *webView;
	NSString *url;
}

@property (nonatomic,retain) NSString *url;

@end
