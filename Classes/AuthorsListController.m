//
//  AuthorsListController.m
//  Manistone
//
//  Created by Eugenio Depalo on 30/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "AuthorsListController.h"
#import "MSAuthorsListDataSource.h"

#import "MSSession.h"

@implementation AuthorsListController

enum {
	kFollowedOrder = 0,
	kActiveOrder,
	kDateOrder
};

static CGFloat kHeaderViewHeight = 50;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithParameters:[query valueForKey:@"parameters"]]) {
		self.title = [query valueForKey:@"title"] ? [query valueForKey:@"title"] : @"Authors";
		_showSort = [[query valueForKey:@"showSort"] boolValue];
		_showSearch = [[query valueForKey:@"showSearch"] boolValue];
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	self.navigationBarTintColor = TTSTYLEVAR(navigationBarTintColor);
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TTApplicationFrame().size.width, 0)];
	
	if(_showSearch) {
		TTTableViewController* searchController = [[[TTTableViewController alloc] init] autorelease];
		searchController.variableHeightRows = YES;
		searchController.dataSource = [[[MSAuthorsListDataSource alloc] initWithParameters:nil] autorelease];
		self.searchViewController = searchController;

		_searchController.searchBar.tintColor = TTSTYLEVAR(controlTintColor);
		
		[headerView addSubview:_searchController.searchBar];

		headerView.frame = TTRectContract(headerView.frame, 0, -_searchController.searchBar.height);
	}
	
	if(_showSort) {
		UISegmentedControl *order = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
																			   @"Followed",
																			   @"Active",
																			   @"Recent",
																			   nil]];
		
		[order addTarget:self action:@selector(orderChanged:) forControlEvents:UIControlEventValueChanged];
		
		order.tintColor = TTSTYLEVAR(controlTintColor);
		order.segmentedControlStyle = UISegmentedControlStyleBar;
		order.selectedSegmentIndex = 0;
		
		CGRect frame = order.frame;
		frame.size.width = headerView.frame.size.width - 40;
		frame.origin.x = 20;
		frame.origin.y = 10 + headerView.bottom;
		
		order.frame = frame;
		
		headerView.frame = TTRectContract(headerView.frame, 0, -kHeaderViewHeight);
		
		[headerView addSubview:order];
		TT_RELEASE_SAFELY(order);
	}
	
	self.tableView.tableHeaderView = headerView;
	
	TT_RELEASE_SAFELY(headerView);
}

- (void)orderChanged:(id)sender {
	UISegmentedControl *order = (UISegmentedControl *)sender;
	
	MSAuthorsListDataSource *dataSource = (MSAuthorsListDataSource *)self.dataSource;
	MSSearchModel *model = (MSSearchModel *)dataSource.model;
	
	switch (order.selectedSegmentIndex) {
		case kFollowedOrder:
			[model.parameters setValue:@"followed" forKey:@"sort"];
			break;
			
		case kActiveOrder:
			[model.parameters setValue:@"active" forKey:@"sort"];
			break;
			
		case kDateOrder:
			[model.parameters setValue:@"date" forKey:@"sort"];
			break;
	}
	
	[self reload];
}

- (void)createModel {
	NSMutableDictionary *completeParameters = [NSMutableDictionary dictionaryWithDictionary:_parameters];
	[completeParameters setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"kAuthorsPerPage"] forKey:@"per_page"];
	
	self.dataSource = [[[MSAuthorsListDataSource alloc] initWithParameters:completeParameters] autorelease];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


@end