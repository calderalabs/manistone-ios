//
//  MSTagListDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 29/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTagListDataSource.h"
#import "MSTag.h"
#import <Three20/Three20+Additions.h>
#import "TTTableTextItem+MSAdditions.h"

@implementation MSTagListDataSource

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"No tags found", @"");
}	

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSSearchModel alloc] initWithResource:[MSTag class] parameters:parameters];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {	
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for(MSTag* tag in _searchModel.results) {
		TTTableLink *item = [TTTableLink itemWithText:
								 [NSString stringWithFormat:@"%@ (%@)", tag.name, [tag.count description]]
														  URL:[tag URLValueWithName:@"show"] userInfo:[NSDictionary dictionaryWithObject:tag.name forKey:@"tag_name"]];
		
		
		[items addObject:item];
	}
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

@end
