//
//  MSTableViewSubItemsDelegate.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableViewSubItemsDelegate.h"
#import "MSTableSubItemsItem.h"
#import "MSSubItemsDataSource.h"
#import "MSTableSubItemsCell.h"

@implementation MSTableViewSubItemsDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	id<TTTableViewDataSource> dataSource = (id<TTTableViewDataSource>)tableView.dataSource;
	id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
	
	if ([object isKindOfClass:[MSTableSubItemsItem class]]) {
		MSTableSubItemsItem *item = (MSTableSubItemsItem *)object;
		
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		
		if([cell isKindOfClass:[MSTableSubItemsCell class]]) {
			MSTableSubItemsCell *subItemsCell = (MSTableSubItemsCell *)cell;
			
			[subItemsCell toggleShown];
		}
		
		if([dataSource isKindOfClass:[MSSubItemsDataSource class]]) {
			MSSubItemsDataSource *subItemsDataSource = (MSSubItemsDataSource *)dataSource;
			
			[subItemsDataSource updateShownItems];
			
			NSMutableArray *indexPaths = [NSMutableArray array];
			
			for(TTTableItem *subItem in item.subItems)
				[indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row + [item.subItems indexOfObject:subItem] + 1
																				  inSection:indexPath.section]];
			
			if(item.shown)
				[tableView insertRowsAtIndexPaths:indexPaths
								 withRowAnimation:UITableViewRowAnimationTop];
			else [tableView deleteRowsAtIndexPaths:indexPaths
								  withRowAnimation:UITableViewRowAnimationTop];
			
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	}
	else
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	
	[_controller didSelectObject:object atIndexPath:indexPath];
}

@end
