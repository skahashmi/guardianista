//
//  ContentListViewController.h
//  Guardian
//
//  Created by Matt Biddulph on 05/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContentListViewController : UITableViewController {
	NSArray *contents;
	IBOutlet UITableView *tableView;
	NSString *filter;
}

@property (nonatomic, retain) NSString *filter;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *contents;
@end
