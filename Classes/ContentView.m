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
@synthesize image;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
   }
    return self;
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0); 
	CGContextFillRect(context, self.bounds);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); 
	CGRect headRect = CGRectMake(50.0f, 0.f, 270.0f, 2000.0f );
	[self.content.headline drawInRect:headRect withFont:[UIFont boldSystemFontOfSize:14]];
	CGSize constSize = { 270.0f, 20000.0f };
	CGSize textSize = [self.content.headline sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:constSize lineBreakMode:UILineBreakModeWordWrap];
	CGRect lblRect = CGRectMake(50.0f, textSize.height, 270.0f, 2000.0f );
	[self.content.standfirst drawInRect:lblRect withFont:[UIFont systemFontOfSize:11]];
}


- (void)dealloc {
	[content release];
    [super dealloc];
}


@end
