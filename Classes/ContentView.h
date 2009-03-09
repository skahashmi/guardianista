//
//  ContentView.h
//  Guardian
//
//  Created by Matt Biddulph on 06/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuardianContent.h"

@interface ContentView : UIView {
	GuardianContent *content;
	UIImage *image;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) GuardianContent *content;
@end
