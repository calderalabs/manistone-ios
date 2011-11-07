//
//  MessageListController.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MessageListController.h"
#import "MSMessageListDataSource.h"

#import "MSCommentsDelegate.h"

static CGFloat kHeaderViewHeight = 44;

enum {
	kInboxFolder = 0,
	kSentFolder
};

@implementation MessageListController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithParameters:[query valueForKey:@"parameters"]]) {
		self.title = NSLocalizedString(@"Messages", @"");
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
																								target:self
																								action:@selector(send:)] autorelease];
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	self.editing = YES;
	self.tableView.allowsSelectionDuringEditing = YES;
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TTApplicationFrame().size.width, 0)];
	
	UISegmentedControl *order = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
																		   NSLocalizedString(@"Inbox", @""),
																		   NSLocalizedString(@"Sent", @""),
																		   nil]];
	
	[order addTarget:self action:@selector(scopeChanged:) forControlEvents:UIControlEventValueChanged];
	
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
	
	[self.view insertSubview:headerView atIndex:0];
	
	self.tableView.frame = CGRectMake(self.tableView.origin.x,
									  headerView.bottom,
									  self.tableView.width,
									  self.tableView.height - headerView.bottom);
	
	TT_RELEASE_SAFELY(headerView);
}

- (void)scopeChanged:(id)sender {
	UISegmentedControl *folder = (UISegmentedControl *)sender;
	
	MSMessageListDataSource *dataSource = (MSMessageListDataSource *)self.dataSource;
	MSSearchModel *model = (MSSearchModel *)dataSource.model;
	
	switch (folder.selectedSegmentIndex) {
		case kInboxFolder:
			[model.parameters setValue:@"inbox" forKey:@"folder"];
			break;
			
		case kSentFolder:
			[model.parameters setValue:@"sent" forKey:@"folder"];
			break;
	}
	
	[self reload];
}

- (void)send:(id)sender {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://message/new"] applyAnimated:YES]];
}

- (void)createModel {
	self.dataSource = [[[MSMessageListDataSource alloc] initWithParameters:_parameters] autorelease];
}


- (id<UITableViewDelegate>)createDelegate {
	return [[[MSCommentsDelegate alloc] initWithController:self] autorelease];
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
