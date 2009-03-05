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
	NSDictionary *tags_grouped;
	IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSDictionary *tags;
@property (nonatomic, retain) NSDictionary *tags_grouped;

- (void)setTagData:(NSDictionary *)t;

@end
