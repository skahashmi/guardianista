//
//  ContentTableViewCell.m
//  Guardian
//
//  Created by Matt Biddulph on 06/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "ContentTableViewCell.h"


@implementation ContentTableViewCell
@synthesize guardianContentView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		CGRect fr = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		guardianContentView = [[ContentView alloc] initWithFrame:fr];
		// guardianContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:guardianContentView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[guardianContentView release];
    [super dealloc];
}

- (void)setGuardianContent:(GuardianContent *)content {
	self.guardianContentView.content = content;
}

@end
