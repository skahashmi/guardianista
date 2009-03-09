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
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		CGRect fr = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		guardianContentView = [[ContentView alloc] initWithFrame:fr];
		guardianContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:guardianContentView];
    }
    return self;
}

- (void)setFrame:(CGRect)f
{
	[super setFrame:f];
	CGRect b = [self bounds];
	b.size.height -= 1; // leave room for the seperator line
	[self.contentView setFrame:b];
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
	if(content.imageUrl) {
		self.imageView = [[UIImageView alloc] init];
		self.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:content.imageUrl]]];
		[self.contentView addSubview:self.imageView];
		[self.imageView release];
		[self setNeedsDisplay];
	}
}

@end
