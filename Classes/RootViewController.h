//
//  RootViewController.h
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright Hackdiary Ltd 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) UITableView *tableView;

@end
