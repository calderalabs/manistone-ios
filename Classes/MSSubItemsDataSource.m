//
//  MSSubItemsDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSSubItemsDataSource.h"
#import "MSTableSubItemsItem.h"
#import "MSTableSubItemsCell.h"

@implementation MSSubItemsDataSource

- (id)initWithItems:(NSArray *)items {
	if(self = [super initWithItems:items])
		_shownItems = [[NSArray alloc] initWithArray:items];
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_shownItems);
	
	[super dealloc];
}

- (void)setItems:(NSMutableArray *)items {
	[super setItems:items];
	
	[self updateShownItems];
}

- (void)updateShownItems {
	NSMutableArray *shownItems = [[NSMutableArray alloc] init];
	
	for(TTTableItem *item in _items) {
		[shownItems addObject:item];
		
		if([item isKindOfClass:[MSTableSubItemsItem class]]) {
			MSTableSubItemsItem *subItemsItem = (MSTableSubItemsItem *)item;
			
			if(subItemsItem.shown)
				[shownItems addObjectsFromArray:subItemsItem.subItems];
		}
	}
	
	TT_RELEASE_SAFELY(_shownItems);
	
	_shownItems = [[NSArray alloc] initWithArray:shownItems];
	
	TT_RELEASE_SAFELY(shownItems);
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {   
    if ([object isKindOfClass:[MSTableSubItemsItem class]]) {  
        return [MSTableSubItemsCell class];  
    } else {  
        return [super tableView:tableView cellClassForObject:object];  
    }  
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_shownItems count];
}

- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
	if (indexPath.row < _shownItems.count) {
		return [_shownItems objectAtIndex:indexPath.row];
	} else {
		return nil;
	}
}

- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object {
	NSUInteger objectIndex = [_shownItems indexOfObject:object];
	if (objectIndex != NSNotFound) {
		return [NSIndexPath indexPathForRow:objectIndex inSection:0];
	}
	return nil;
}

- (NSIndexPath*)indexPathOfItemWithUserInfo:(id)userInfo {
	for (NSInteger i = 0; i < _shownItems.count; ++i) {
		TTTableItem* item = [_shownItems objectAtIndex:i];
		if (item.userInfo == userInfo) {
			return [NSIndexPath indexPathForRow:i inSection:0];
		}
	}
	return nil;
}

@end
