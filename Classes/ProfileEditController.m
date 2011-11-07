//
//  ProfileEditController.m
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "ProfileEditController.h"
#import "MSProfileEditDataSource.h"
#import "MSSession.h"
#import "MSMemberRequest.h"
#import "MSCollectionRequest.h"

@implementation ProfileEditController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if(self.dataSource)
		[self refresh];
}

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithStyle:UITableViewStyleGrouped]) {
		if([query valueForKey:@"user"]) {
			_user = [[query valueForKey:@"user"] copy];
			
		}
		else {
			_user = [[MSUser alloc] init];
			
			_user.shareEmail = [NSNumber numberWithBool:YES];
			_user.shareBirthday = [NSNumber numberWithBool:YES];
		}
		
		_delegate = [[query valueForKey:@"delegate"] retain];

		self.title = _user.uid ? NSLocalizedString(@"Edit Profile", @"") : NSLocalizedString(@"Sign Up", @"");
		
		self.variableHeightRows = YES;
		self.autoresizesForKeyboard = YES;
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																							  target:self
																							  action:@selector(cancel:)];
		
		if(_user.uid) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																							   target:self
																							   action:@selector(save:)];
		}
		else {
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																								   target:self
																								   action:@selector(save:)];
		}
	}
	
	return self;
}

- (void)save:(id)sender {
	MSProfileEditDataSource *dataSource = (MSProfileEditDataSource *)self.dataSource;
	
	[dataSource.firstResponder resignFirstResponder];
	
	MSAPIRequest *request;
	
	request = _user.uid ? [[MSMemberRequest alloc] initWithResource:@"accounts"
												  member:[_user.uid description]
												  action:MSMemberRequestActionUpdate
											  parameters:[NSDictionary dictionaryWithObject:[_user attributes] forKey:@"user"]
															delegate:_delegate] :
	[[MSCollectionRequest alloc] initWithResource:@"accounts"
										   action:MSCollectionRequestActionCreate
									   parameters:[NSDictionary dictionaryWithObject:[_user attributes] forKey:@"user"]
										 delegate:_delegate];
	
	[request.delegates addObject:self];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
	
	[self startActivity:_user.uid ? NSLocalizedString(@"Updating profile...", @"") : NSLocalizedString(@"Signing up...", @"")];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	if(!_user.uid) {
		[self stopActivity];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Great!", @"")
														message:[NSString stringWithFormat:NSLocalizedString(@"Your account has been successfully created. "
																 "You should soon receive an email with details for the activation to this address: %@.\n"
																 "Welcome aboard, %@!", @""), _user.email, _user.name]
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		
		[alert show];
		
		TT_RELEASE_SAFELY(alert);
	}
	else {
		[[TTURLCache sharedCache] removeURL:[_user remotePhotoURLWithStyle:@"normal"] fromDisk:YES];
		[[TTURLCache sharedCache] removeURL:[_user remotePhotoURLWithStyle:@"thumb"] fromDisk:YES];
		
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	if(error.code == 422) {
		TTURLJSONResponse *response = (TTURLJSONResponse *)request.response;
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_user.uid ? NSLocalizedString(@"Unable to update profile", @"") : NSLocalizedString(@"Unable to sign up", @"")
														message:[[response.rootObject valueForKey:@"errors"] componentsJoinedByString:@"\n"]
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"OK", nil];
		
		[alert show];
		TT_RELEASE_SAFELY(alert);
	}
	
	[self stopActivity];
}

- (void)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)createModel {
	self.dataSource = [[[MSProfileEditDataSource alloc] initWithUserObject:_user] autorelease];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_delegate);
	
	[super dealloc];
}

@end
