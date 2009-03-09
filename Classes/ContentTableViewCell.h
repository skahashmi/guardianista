//
//  ContentTableViewCell.h
//  Guardian
//
//  Created by Matt Biddulph on 06/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuardianContent.h"
#import "ContentView.h"

@interface ContentTableViewCell : UITableViewCell {
	ContentView *guardianContentView;
	UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) ContentView *guardianContentView;

- (void)setGuardianContent:(GuardianContent *)content;
@end
