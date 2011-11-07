//
//  ProfileController.m
//  Manistone
//
//  Created by Eugenio Depalo on 03/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "ProfileController.h"
#import "MSSession.h"
#import "MSAuthorDataSource.h"

@implementation ProfileController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	self = [super initWithUid:[[MSSession applicationSession].user.uid unsignedIntegerValue]];
	
	return self;
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];

	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																							target:self
																							  action:@selector(edit:)] autorelease] animated:YES];
}

- (void)createModel {
	self.dataSource = [[[MSAuthorDataSource alloc] initWithUid:_uid
													parameters:[NSDictionary dictionaryWithObject:
																[NSNumber numberWithBool:YES] forKey:@"include_privacy_settings"]] autorelease];
}

- (void)edit:(id)sender {
	MSAuthorDataSource *dataSource = (MSAuthorDataSource *)self.dataSource;

	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://profile/edit"] applyAnimated:YES] applyQuery:
											[NSDictionary dictionaryWithObjectsAndKeys:
											 dataSource.remoteObjectModel, @"delegate",
											 dataSource.remoteObjectModel.remoteObject, @"user",
											 nil]]];
}

@end
