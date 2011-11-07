//
//  MSDedicationDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 19/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSDedicationDataSource.h"
#import "MSUser.h";
#import "MSTableAuthorItem.h"
#import "MSTableAuthorSmallCell.h"

@implementation MSDedicationDataSource

- (id)initWithParameters:(NSDictionary *)parameters {
	self = [super initWithParameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"dedication"]];
	
	return self;
}

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSSearchModel alloc] initWithResource:[MSUser class] parameters:parameters];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	for(MSUser *user in _searchModel.results) {
		MSTableAuthorItem *item = [MSTableAuthorItem itemWithAuthor:user];
		item.accessoryURL = [user URLValueWithName:@"show"];
		item.userInfo = user;
		[items addObject:item];
	}

	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[MSTableAuthorItem class]])
		return [MSTableAuthorSmallCell class];
	else
		return [super tableView:tableView cellClassForObject:object];
}

@end
