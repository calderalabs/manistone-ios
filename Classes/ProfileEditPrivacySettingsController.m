//
//  ProfileEditPrivacySettingsController.m
//  Manistone
//
//  Created by Eugenio Depalo on 08/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "ProfileEditPrivacySettingsController.h"

@implementation ProfileEditPrivacySettingsController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithStyle:UITableViewStyleGrouped]) {
		_user = [[query valueForKey:@"user"] retain];
		
		self.title = NSLocalizedString(@"Privacy Settings", @"");
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																								target:self
																								action:@selector(save:)] autorelease];
	}
	
	return self;
}

- (void)save:(id)sender {
	_user.shareEmail = [NSNumber numberWithBool:_emailSwitch.on];
	_user.shareBirthday = [NSNumber numberWithBool:_birthdaySwitch.on];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_user);
	TT_RELEASE_SAFELY(_emailSwitch);
	TT_RELEASE_SAFELY(_birthdaySwitch);	

	[super dealloc];
}

- (void)createModel {
	_emailSwitch = [[UISwitch alloc] init];
	_emailSwitch.on = [_user.shareEmail boolValue];
	
	_birthdaySwitch = [[UISwitch alloc] init];
	_birthdaySwitch.on = [_user.shareBirthday boolValue];
	
	self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
					   NSLocalizedString(@"Select what you want to share", @""),
					   [TTTableControlItem itemWithCaption:NSLocalizedString(@"Email", @"") control:_emailSwitch],
					   [TTTableControlItem itemWithCaption:NSLocalizedString(@"Birthday", @"") control:_birthdaySwitch],
					   nil];
}

@end
