//
//  LocalStonesListController.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "LocalStonesListController.h"

#import "MSLocalStoneListDataSource.h"

@implementation LocalStonesListController

@synthesize picker = _picker;

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		self.title = NSLocalizedString(@"Stone Bag", @"");
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																								target:self
																								action:@selector(cancel:)] autorelease];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																							   target:self
																							   action:@selector(add:)] autorelease];
		
		self.variableHeightRows = YES;
		
		_picker = [[query valueForKey:@"picker"] boolValue];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self refresh];
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)add:(id)sender {
	[[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"tt://local_stone/new"] applyAnimated:YES]];
}

- (void)createModel {
	self.dataSource = [[[MSLocalStoneListDataSource alloc] init] autorelease];
}

@end
