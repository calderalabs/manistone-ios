//
//  MSStackListDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 21/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStackListDataSource.h"
#import "MSSearchModel.h"
#import "MSTableStackItem.h"
#import "MSTableStackItemCell.h"
#import "MSStack.h"

@implementation MSStackListDataSource

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"No stacks found", @"");
}

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSSearchModel alloc] initWithResource:[MSStack class] parameters:parameters];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {	
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for(MSStack* stack in _searchModel.results)
		[items addObject:[MSTableStackItem itemWithStack:stack]];
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[MSTableStackItem class]])
		return [MSTableStackItemCell class];
	else
		return [super tableView:tableView cellClassForObject:object];
}

@end
