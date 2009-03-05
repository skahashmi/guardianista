//
//  TagListViewController.h
//  Guardian
//
//  Created by Matt Biddulph on 05/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TagListViewController : UITableViewController {
	NSDictionary *tags;
	IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSDictionary *tags;

@end
