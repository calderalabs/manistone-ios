//
//  MSFollowedDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 09/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSFollowedDataSource.h"
#import "MSUser.h"
#import "MSTableAuthorItem.h"
#import "MSTableFollowedAuthorCell.h"

@implementation MSFollowedDataSource

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSSearchModel alloc] initWithResource:[MSUser class] collectionName:@"subscriptions" parameters:parameters];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {	
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for(MSUser* author in _searchModel.results) {
		MSTableAuthorItem *item = [MSTableAuthorItem itemWithAuthor:author];
		
		item.URL = [NSString stringWithFormat:@"tt://stones/%@", NSLocalizedString(@"Stones", @"")];
		item.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObject:author.uid forKey:@"user_id"], @"parameters", [NSNumber numberWithBool:YES], @"markUnread", nil];
		[items addObject:item];
	}
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"You do not follow anyone", @"");
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object { 
	if ([object isKindOfClass:[MSTableAuthorItem class]])
		return [MSTableFollowedAuthorCell class];
	else
		return [super tableView:tableView cellClassForObject:object];
}

@end
