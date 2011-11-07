//
//  TagsListController.m
//  Manistone
//
//  Created by Eugenio Depalo on 29/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "TagsListController.h"
#import "MSTagListDataSource.h"


@implementation TagsListController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithParameters:[query valueForKey:@"parameters"]]) {
		self.title = NSLocalizedString(@"Tags", @"");
	}
	
	return self;
}

- (void)updateView {
	[super updateView];
	
	MSTagListDataSource *dataSource = (MSTagListDataSource *)self.dataSource;
	MSSearchModel *model = (MSSearchModel *)dataSource.model;
	
	MSTagListDataSource *searchDataSource = (MSTagListDataSource *)self.searchViewController.dataSource;
	MSSearchModel *searchModel = (MSSearchModel *)searchDataSource.model;
	
	searchModel.parameters = model.parameters;
}

- (void)modelDidChange:(id<TTModel>)model 
{ 
	[super modelDidChange:model]; 
	
}

- (void)loadView {
	[super loadView];
	
	TTTableViewController* searchController = [[[TTTableViewController alloc] init] autorelease];
	searchController.variableHeightRows = YES;
	searchController.dataSource = [[[MSTagListDataSource alloc] initWithParameters:nil] autorelease];
	self.searchViewController = searchController;

	_searchController.searchBar.tintColor = TTSTYLEVAR(controlTintColor);
	
	self.tableView.tableHeaderView = _searchController.searchBar;
}

- (void)createModel {
	NSMutableDictionary *completeParameters = [NSMutableDictionary dictionaryWithDictionary:_parameters];
	[completeParameters setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"kTagsPerPage"] forKey:@"per_page"];
	
	self.dataSource = [[[MSTagListDataSource alloc] initWithParameters:[NSDictionary dictionaryWithDictionary:completeParameters]] autorelease];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end
