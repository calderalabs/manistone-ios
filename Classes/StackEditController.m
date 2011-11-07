//
//  StackEditController.m
//  Manistone
//
//  Created by Eugenio Depalo on 23/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StackEditController.h"
#import "MSCollectionRequest.h"
#import "MSMemberRequest.h"

@implementation StackEditController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		if([query valueForKey:@"stack"]) {
			_stack = [[query valueForKey:@"stack"] copy];
			_isNewStack = NO;
		}
		else {
			_stack = [[MSStack alloc] init];
			_isNewStack = YES;
		}
		
		_delegate = [[query valueForKey:@"delegate"] retain];
		
		self.title = _stack.uid ? NSLocalizedString(@"Edit Stack", @"") : NSLocalizedString(@"Create Stack", @"");
		
		self.tableViewStyle = UITableViewStyleGrouped;
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																							   target:self
																							   action:@selector(cancel:)] autorelease];
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																								target:self
																								action:@selector(done:)] autorelease];
	}
	
	return self;
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)done:(id)sender {	
	[_nameField resignFirstResponder];
	
	_stack.name = _nameField.text;
	
	MSAPIRequest *request;
	
	if(_stack.uid)
		request = [[[MSMemberRequest alloc] initWithResource:@"stacks"
													  member:[_stack.uid description]
													  action:MSMemberRequestActionUpdate
												  parameters:[NSDictionary dictionaryWithObject:[_stack attributes] forKey:@"stack"]
													delegate:_delegate] autorelease];
	else
		request = [[[MSCollectionRequest alloc] initWithResource:@"stacks"
														  action:MSCollectionRequestActionCreate
													  parameters:[NSDictionary dictionaryWithObject:[_stack attributes] forKey:@"stack"]
														delegate:_delegate] autorelease];
	
	[request.delegates addObject:self];
	[request send];
	
	[self startActivity:_stack.uid ? NSLocalizedString(@"Updating stack...", @"") : NSLocalizedString(@"Creating stack...", @"")];
}

- (void)loadView {
	[super loadView];
	
	self.tableView.contentInset = UIEdgeInsetsMake((TTKeyboardNavigationFrame().size.height -
													ttkDefaultRowHeight -
													ttkGroupedTableCellInset) / 2,
												   0,
												   0,
												   0);
	
	self.tableView.scrollEnabled = NO;
	
	_nameField = [[UITextField alloc] init];
	_nameField.text = _stack.name;
	[_nameField becomeFirstResponder];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	if(error.code == 422) {
		TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to create stack", @"")
														message:[[response.rootObject valueForKey:@"errors"] componentsJoinedByString:@"\n"]
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		
		[alert show];
		TT_RELEASE_SAFELY(alert);
	}
	
	[self stopActivity];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_nameField);
	
	[super dealloc];
}

- (void)createModel {
	self.dataSource = [TTListDataSource dataSourceWithItems:[NSMutableArray arrayWithObject:_nameField]];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	[self dismissModalViewControllerAnimated:YES];
}

@end
