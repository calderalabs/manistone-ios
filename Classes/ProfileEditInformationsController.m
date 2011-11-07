//
//  ProfileEditInformationsController.m
//  Manistone
//
//  Created by Eugenio Depalo on 08/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "ProfileEditInformationsController.h"

@implementation ProfileEditInformationsController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithStyle:UITableViewStyleGrouped]) {
		_user = [[query valueForKey:@"user"] retain];
		_informations = [_user.informations copy];
		
		self.variableHeightRows = YES;
		self.tableView.scrollEnabled = NO;
		
		self.title = NSLocalizedString(@"Informations", @"");
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																								target:self
																								action:@selector(save:)] autorelease];
	}
	
	return self;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[_informationsView becomeFirstResponder];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_user);
	TT_RELEASE_SAFELY(_informations);
	TT_RELEASE_SAFELY(_informationsView);
	
	[super dealloc];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	_informations = [textView.text retain];
}

- (void)createModel {
	_informationsView = [[UITextView alloc] initWithFrame:TTRectContract(TTKeyboardNavigationFrame(), 0,  kTableCellMargin * 2)];
	_informationsView.font = [UIFont systemFontOfSize:15];
	_informationsView.delegate = self;
	
	self.dataSource = [TTListDataSource dataSourceWithObjects:_informationsView, nil];
}

- (void)save:(id)sender {
	[_informationsView resignFirstResponder];
	
	_user.informations = _informations;
	[self.navigationController popViewControllerAnimated:YES];
}

@end
