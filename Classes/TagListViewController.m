//
//  TagListViewController.m
//  Guardian
//
//  Created by Matt Biddulph on 05/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "GuardianAppDelegate.h"
#import "TagListViewController.h"
#import "ContentListViewController.h"
#import "RegexKitLite.h"


@implementation TagListViewController
@synthesize tableView;
@synthesize tags;
@synthesize tags_grouped;

- (void)setTagData:(NSDictionary *)t {
	self.tags = t;
	NSMutableDictionary *g = [NSMutableDictionary dictionary];
	for(NSString *name in t) {
		NSString *filter = [[t objectForKey:name] lowercaseString];
		NSArray *levels = [filter componentsSeparatedByRegex:@"/"];
		// NSLog(@"%@ -> %@", filter, levels);
		NSString *group = [levels objectAtIndex:1];
		if(![g objectForKey:group]) {
			[g setObject:[NSMutableDictionary dictionary] forKey:group];
		}
		[[g objectForKey:group] setObject:filter forKey:name];
	}
	self.tags_grouped = g;
	// NSLog(@"%@", g);
	[[self tableView] reloadData];
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if(!self.tags) {
		self.tags = [NSDictionary dictionary];
	
		GuardianAppDelegate *delegate = (GuardianAppDelegate *)[[UIApplication sharedApplication] delegate];
		[delegate.guardian allSubjectsWithDelegate:self didSucceedSelector:@selector(setTagData:)];
	} else {
		NSLog(@"Not populating tag list view from API, already got some tags.");
	}
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if([self.tags_grouped count] == 0) {
		return 1;
	}
    return [self.tags_grouped count];
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section { 
	NSArray *sections = [[self.tags_grouped allKeys] sortedArrayUsingSelector:@selector(compare:)];
	return [sections objectAtIndex:section];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *sections = [[self.tags_grouped allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return [[self.tags_grouped objectForKey:[sections objectAtIndex:section]] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *sections = [[self.tags_grouped allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSDictionary *section = [self.tags_grouped objectForKey:[sections objectAtIndex:indexPath.section]];
	NSArray *labels = [[section allKeys] sortedArrayUsingSelector:@selector(compare:)];
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.text = [labels objectAtIndex:indexPath.row];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *sections = [[self.tags_grouped allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSDictionary *section = [self.tags_grouped objectForKey:[sections objectAtIndex:indexPath.section]];
	NSArray *filters = [[section allValues] sortedArrayUsingSelector:@selector(compare:)];
	
	ContentListViewController *controller = [[ContentListViewController alloc]
										  initWithNibName:@"ContentListViewController" 
										  bundle:nil]; 
	controller.filter = [filters objectAtIndex: indexPath.row];
	NSLog(@"Going to content list with filter %@", controller.filter);
	[self.navigationController pushViewController:controller animated:YES]; 
	[controller release]; 	
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[tableView release];
	[tags release];
	[tags_grouped release];
    [super dealloc];
}


@end

