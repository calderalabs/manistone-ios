//
//  ProfileEditBirthdayController.m
//  Manistone
//
//  Created by Eugenio Depalo on 08/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "ProfileEditBirthdayController.h"

@implementation ProfileEditBirthdayController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self init]) {
		_user = [[query valueForKey:@"user"] retain];
		_birthday = [_user.birthday copy];
		
		self.view.backgroundColor = TTSTYLEVAR(tableGroupedBackgroundColor);
		
		self.title = NSLocalizedString(@"Select Birthday", @"");
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																								target:self
																								action:@selector(save:)] autorelease];
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
	[picker sizeToFit];
	picker.frame = CGRectMake(0, floor((self.view.height - picker.height) / 2), picker.width, picker.height);
	picker.date = _birthday;
	
	picker.datePickerMode = UIDatePickerModeDate;
	[picker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:picker];
	TT_RELEASE_SAFELY(picker);
}

- (void)dateDidChange:(id)sender {
	_birthday = [((UIDatePicker *)sender).date retain];
}

- (void)save:(id)sender {
	_user.birthday = _birthday;
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_user);
	TT_RELEASE_SAFELY(_birthday);
	
	[super dealloc];
}



@end
