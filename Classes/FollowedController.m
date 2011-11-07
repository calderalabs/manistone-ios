//
//  FollowedController.m
//  Manistone
//
//  Created by Eugenio Depalo on 09/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "FollowedController.h"
#import "MSFollowedDataSource.h"

@implementation FollowedController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithParameters:[query valueForKey:@"parameters"]]) {
		self.title = NSLocalizedString(@"Followed", @"");
		self.variableHeightRows = YES;
	}
	
	return self;
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

- (void)createModel {
	self.dataSource = [[[MSFollowedDataSource alloc] initWithParameters:nil] autorelease];
}

@end
