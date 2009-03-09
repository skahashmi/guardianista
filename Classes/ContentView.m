//
//  ContentView.m
//  Guardian
//
//  Created by Matt Biddulph on 06/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "ContentView.h"


@implementation ContentView
@synthesize content;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0); 
	CGContextFillRect(context, self.bounds);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); 
	[self.content.headline drawInRect:self.bounds withFont:[UIFont boldSystemFontOfSize:14]];
	CGSize constSize = { 320.0f, 20000.0f };
	CGSize textSize = [self.content.headline sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:constSize lineBreakMode:UILineBreakModeWordWrap];
	CGRect lblRect = CGRectMake(0.0f, textSize.height, 320.0f, self.bounds.size.height - textSize.height+textSize.height/3 );
	[self.content.standfirst drawInRect:lblRect withFont:[UIFont systemFontOfSize:11]];
}


- (void)dealloc {
	[content release];
    [super dealloc];
}


@end
