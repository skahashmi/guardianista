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
	UIImageView *imageView;
	UILabel *headline;
	UILabel *standfirst;
	GuardianContent *guardianContent;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *headline;
@property (nonatomic, retain) UILabel *standfirst;
@property (nonatomic, retain) GuardianContent *guardianContent;

- (void)setGuardianContent:(GuardianContent *)content;
@end
