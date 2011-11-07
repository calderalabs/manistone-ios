//
//  MSStoneListDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 08/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStone.h"
#import "MSStoneListDataSource.h"
#import "MSTableStoneItem.h"
#import "MSTableStoneItemCell.h"
#import "MSStonesSearchModel.h"

@implementation MSStoneListDataSource

@synthesize markUnread = _markUnread;

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"No stones found", @"");
}	

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSStonesSearchModel alloc] initWithParameters:parameters];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	[super tableViewDidLoadModel:tableView];
	
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for(MSStone* stone in _searchModel.results) {
		MSTableStoneItem *item = [MSTableStoneItem itemWithStone:stone];
		item.markUnread = _markUnread;
		[items addObject:item];
	}
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[MSTableStoneItem class]])
		return [MSTableStoneItemCell class];
	else
		return [super tableView:tableView cellClassForObject:object];
}

@end
