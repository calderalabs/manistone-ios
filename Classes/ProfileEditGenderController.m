//
//  ProfileEditGenderController.m
//  Manistone
//
//  Created by Eugenio Depalo on 08/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "ProfileEditGenderController.h"

@implementation ProfileEditGenderController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithStyle:UITableViewStyleGrouped]) {
		_user = [[query valueForKey:@"user"] retain];
		_gender = _user.gender;
		
		self.title = NSLocalizedString(@"Select Gender", @"");
		
		self.tableView.backgroundColor = TTSTYLEVAR(tableGroupedBackgroundColor);
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																							   target:self
																							   action:@selector(save:)] autorelease];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_user);
	
	[super dealloc];
}

- (void)save:(id)sender {
	_user.gender = _gender;
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_gender = (MSUserGender)indexPath.row;
	
	[tableView reloadData];
	[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckmarkCell"];
	
	if(!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckmarkCell"] autorelease];
	}
	
	switch (indexPath.row) {
		case 0:
			if(_gender == MSUserGenderUnspecified)
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			else
				cell.accessoryType = UITableViewCellAccessoryNone;
			
			cell.textLabel.text = NSLocalizedString(@"Unspecified", @"");
			break;
		case 1:
			if(_gender == MSUserGenderMale)
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			else
				cell.accessoryType = UITableViewCellAccessoryNone;
			
			cell.textLabel.text = NSLocalizedString(@"Male", @"");
			break;
		case 2:
			if(_gender == MSUserGenderFemale)
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			else
				cell.accessoryType = UITableViewCellAccessoryNone;
			
			cell.textLabel.text = NSLocalizedString(@"Female", @"");
			break;
	}
	
	return cell;
}

@end
