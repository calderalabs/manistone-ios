//
//  AddToStackController.m
//  Manistone
//
//  Created by Eugenio Depalo on 23/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "AddToStackController.h"
#import "MSAddToStackDataSource.h"

#import "MSSession.h"

@implementation AddToStackController

enum {
	kDateOrder = 0,
	kVotesOrder,
	kViewsOrder
};

- (id)initWithUid:(NSUInteger)uid query:(NSDictionary *)query {
	if(self = [self init]) {
		self.title = NSLocalizedString(@"Add to Stack", @"");
		
		NSMutableDictionary *completeParameters = [NSMutableDictionary dictionaryWithDictionary:query];
		[completeParameters setValue:[NSNumber numberWithUnsignedInteger:uid] forKey:@"stone_id"];
		[completeParameters setValue:[MSSession applicationSession].user.uid forKey:@"user_id"];
		
		_parameters = [[NSDictionary alloc] initWithDictionary:completeParameters];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_parameters);
	
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if(self.dataSource)
		[self reload];
}

- (void)loadView {
	[super loadView];
	
	self.navigationBarTintColor = TTSTYLEVAR(navigationBarTintColor);
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																							target:self
																							action:@selector(add:)] autorelease];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)add:(id)sender {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://stack/new"] applyAnimated:YES]];
}


- (void)createModel {
	MSAddToStackDataSource *dataSource = [[[MSAddToStackDataSource alloc] initWithParameters:_parameters] autorelease];
	dataSource.delegate = self;
	
	self.dataSource = dataSource;
}

- (void)requestDidStartLoad:(TTURLRequest *)request {
	[self startActivity:NSLocalizedString(@"Adding to stack...", @"")];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
	[self stopActivity];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end