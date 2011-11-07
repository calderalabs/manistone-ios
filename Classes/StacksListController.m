//
//  StacksListController.m
//  Manistone
//
//  Created by Eugenio Depalo on 21/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StacksListController.h"
#import "MSStackListDataSource.h"

#import "MSSession.h"

@implementation StacksListController

enum {
	kDateOrder = 0,
	kVotesOrder,
	kViewsOrder
};

static CGFloat kHeaderViewHeight = 50;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithParameters:[query valueForKey:@"parameters"]]) {
		self.title = [query valueForKey:@"title"] ? [query valueForKey:@"title"] : NSLocalizedString(@"Stacks", @"");
		_showSort = [[query valueForKey:@"showSort"] boolValue];
		_showSearch = [[query valueForKey:@"showSearch"] boolValue];
	}
	
	return self;
}

- (void)updateView {
	[super updateView];
	
	MSStackListDataSource *dataSource = (MSStackListDataSource *)self.dataSource;
	MSSearchModel *model = (MSSearchModel *)dataSource.model;
	
	MSStackListDataSource *searchDataSource = (MSStackListDataSource *)self.searchViewController.dataSource;
	MSSearchModel *searchModel = (MSSearchModel *)searchDataSource.model;
	
	searchModel.parameters = model.parameters;
}

- (void)loadView {
	[super loadView];
	
	self.navigationBarTintColor = TTSTYLEVAR(navigationBarTintColor);
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TTApplicationFrame().size.width, 0)];
	
	if(_showSearch) {
		TTTableViewController* searchController = [[[TTTableViewController alloc] init] autorelease];
		searchController.variableHeightRows = YES;
		searchController.dataSource = [[[MSStackListDataSource alloc] initWithParameters:nil] autorelease];
		self.searchViewController = searchController;

		_searchController.searchBar.tintColor = TTSTYLEVAR(controlTintColor);
		
		[headerView addSubview:_searchController.searchBar];
		
		headerView.frame = TTRectContract(headerView.frame, 0, -_searchController.searchBar.height);
	}
	
	if(_showSort) {
		UISegmentedControl *order = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
																			   @"Recent",
																			   @"Popular",
																			   @"Viewed",
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
		[headerView addSubview:order];
		TT_RELEASE_SAFELY(order);
		
		headerView.frame = TTRectContract(headerView.frame, 0, -kHeaderViewHeight);
	}
	
	self.tableView.tableHeaderView = headerView;
	
	TT_RELEASE_SAFELY(headerView);
}

- (void)orderChanged:(id)sender {
	UISegmentedControl *order = (UISegmentedControl *)sender;
	
	MSStackListDataSource *dataSource = (MSStackListDataSource *)self.dataSource;
	MSSearchModel *model = (MSSearchModel *)dataSource.model;
	
	switch (order.selectedSegmentIndex) {
		case kDateOrder:
			[model.parameters setValue:@"date" forKey:@"sort"];
			break;
			
		case kVotesOrder:
			[model.parameters setValue:@"votes" forKey:@"sort"];
			break;
			
		case kViewsOrder:
			[model.parameters setValue:@"views" forKey:@"sort"];
			break;
	}
	
	[self reload];
}


- (void)createModel {
	NSMutableDictionary *completeParameters = [NSMutableDictionary dictionaryWithDictionary:_parameters];
	[completeParameters setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"kStacksPerPage"] forKey:@"per_page"];
	
	self.dataSource = [[[MSStackListDataSource alloc] initWithParameters:[NSDictionary dictionaryWithDictionary:completeParameters]] autorelease];
}


- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.dataSource search:searchBar.text];
	
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	MSSearchModel *model = (MSSearchModel *)self.dataSource.model;
	
	[model.parameters removeObjectForKey:@"q"];
	[model load:TTURLRequestCachePolicyNone more:NO];
	
	[searchBar resignFirstResponder];
}

@end
