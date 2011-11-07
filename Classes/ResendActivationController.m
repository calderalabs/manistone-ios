//
//  ResendActivationController.m
//  Manistone
//
//  Created by Eugenio Depalo on 01/12/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "ResendActivationController.h"
#import "MSAPIRequest.h"

@implementation ResendActivationController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		self.tableViewStyle = UITableViewStyleGrouped;
		
		self.title = NSLocalizedString(@"Resend Activation", @"");
		
		_emailField = [[UITextField alloc] init];
		_emailField.placeholder = NSLocalizedString(@"Email", @"");
		_emailField.keyboardType = UIKeyboardTypeEmailAddress;
		_emailField.returnKeyType = UIReturnKeyNext;
		_emailField.autocorrectionType = UITextAutocorrectionTypeNo;
		_emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		_emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
		_emailField.clearsOnBeginEditing = NO;
		[_emailField becomeFirstResponder];
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", @"")
																				   style:UIBarButtonItemStyleDone
																				  target:self
																				  action:@selector(send:)] autorelease];
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																							   target:self
																							   action:@selector(cancel:)] autorelease];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_emailField);
	
	[super dealloc];
}

- (void)loadView {
	[super loadView];
	
	self.tableView.contentInset = UIEdgeInsetsMake((TTKeyboardNavigationFrame().size.height -
											   (ttkDefaultRowHeight) -
											   (ttkGroupedTableCellInset)) / 2,
											  0,
											  0,
											  0);
	
	self.tableView.scrollEnabled = NO;
}

- (void)createModel {
	self.dataSource = [TTListDataSource dataSourceWithObjects:_emailField, nil];
}

- (void)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)send:(id)sender {
	[_emailField resignFirstResponder];
	
	MSAPIRequest *request = [[MSAPIRequest alloc] initWithController:@"accounts"
															  action:@"resend_activation"
															  method:@"POST"
														  parameters:[NSDictionary dictionaryWithObject:_emailField.text forKey:@"email"]
															delegate:self];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	[self startActivity:NSLocalizedString(@"Resending activation...", @"")];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	[self stopActivity];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Activation sent", @"")
														message:NSLocalizedString(@"Your activation email has been sent succesfully. You may now proceed with your account activation by following the link sent to you.", @"")
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
	
	[alertView show];
	
	TT_RELEASE_SAFELY(alertView);
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
	[self stopActivity];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Problem sending activation", @"")
														message:NSLocalizedString(@"There was a problem sending the activation email. Please check that you have entered your email address correctly and try again.", @"")
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	
	[alertView show];
	
	TT_RELEASE_SAFELY(alertView);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
