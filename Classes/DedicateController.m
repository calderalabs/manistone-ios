//
//  DedicateController.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "DedicateController.h"
#import "MSDedicateDataSource.h"
#import "MSDedicateDelegate.h"

@implementation DedicateController

@synthesize uid = _uid;

- (id)initWithUid:(NSUInteger)uid query:(NSDictionary *)query {
	if(self = [self initWithParameters:[query valueForKey:@"parameters"]]) {
		_uid = uid;
		
		self.title = NSLocalizedString(@"Dedicate", @"");
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																							   target:self
																							   action:@selector(cancel:)] autorelease];
		
		self.autoresizesForKeyboard = YES;
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, TTNavigationFrame().size.width, TT_TOOLBAR_HEIGHT)];
	
	searchBar.tintColor = TTSTYLEVAR(controlTintColor);
	searchBar.delegate = self;
	
	[self.view addSubview:searchBar];
	
	self.tableView.height -= searchBar.height;
	self.tableView.top = searchBar.bottom;
	
	[searchBar becomeFirstResponder];
	
	TT_RELEASE_SAFELY(searchBar);
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)createModel {
	self.dataSource = [[MSDedicateDataSource alloc] initWithParameters:_parameters];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[MSDedicateDelegate alloc] initWithController:self] autorelease];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	
	self.searchDataSource.items = nil;
	[self.tableView reloadData];
	[self.searchModel search:searchBar.text];
}

@end
