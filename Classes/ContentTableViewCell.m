//
//  ContentTableViewCell.m
//  Guardian
//
//  Created by Matt Biddulph on 06/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "ContentTableViewCell.h"


@implementation ContentTableViewCell
@synthesize guardianContent, imageView, headline, standfirst;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		headline = [[UILabel alloc] initWithFrame:CGRectZero];
		headline.textColor = [UIColor blackColor];
		headline.font = [UIFont boldSystemFontOfSize:18.0];
		headline.backgroundColor = [UIColor clearColor];
		
		standfirst = [[UILabel alloc] initWithFrame:CGRectZero];
		standfirst.textColor = [UIColor darkGrayColor];
		standfirst.font = [UIFont systemFontOfSize:12.0];
		standfirst.backgroundColor = [UIColor clearColor];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		
		[self.contentView addSubview:headline];
		[self.contentView addSubview:standfirst];
		[self.contentView addSubview:imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect baseRect = CGRectInset(self.contentView.bounds, 10, 0);
	CGRect rect = baseRect;
	rect.origin.y += -7;
	rect.size.width = self.contentView.bounds.size.width - 70;
	headline.frame = rect;
	
	rect.origin.y += 20;
	standfirst.frame = rect;
	
	rect.size.width = 40;
	rect.size.height = 40;
	rect.origin.x = self.contentView.bounds.size.width - 50;
	rect.origin.y += -7;
	imageView.frame = rect;
}

- (void)dealloc {
	[imageView release];
	[headline release];
	[guardianContent release];
	[standfirst release];
    [super dealloc];
}

- (void)setGuardianContent:(GuardianContent *)content {
	guardianContent = content;
	self.headline.text = content.headline;
	self.standfirst.text = content.standfirst;
	if(content.imageUrl) {
		self.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:content.imageUrl]]];
	} else {
		self.imageView.image = nil;
	}
}

@end
