//
//  MSAuthorsListDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 31/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSAuthorsListDataSource.h"
#import "MSUser.h"
#import "MSTableAuthorItem.h"
#import "MSTableAuthorItemCell.h"

@implementation MSAuthorsListDataSource

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"No authors found", @"");
}	

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSSearchModel alloc] initWithResource:[MSUser class] parameters:parameters];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {	
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for(MSUser* author in _searchModel.results)
		[items addObject:[MSTableAuthorItem itemWithAuthor:author]];
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[MSTableAuthorItem class]])
		return [MSTableAuthorItemCell class];
	else
		return [super tableView:tableView cellClassForObject:object];
}


@end
