//
//  MSLocalStoneListDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSLocalStoneListDataSource.h"
#import "MSLocalStonesManager.h"
#import "MSStone.h"
#import "LocalStonesListController.h"
#import "MSTableLocalStoneItem.h"
#import "MSTableLocalStoneItemCell.h"

@implementation MSLocalStoneListDataSource

- (UIImage *)imageForEmpty {
	return [UIImage imageNamed:@"stones.png"];
}

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"Your stone bag is empty!", @"");
}

- (NSString *)subtitleForEmpty {
	return NSLocalizedString(@"To create a stone without publishing it to the world, tap the add button in the top right corner. You will be able to engrave your stone whenever you have an active connection.", @"");
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	NSMutableArray *items = [NSMutableArray array];
	
	TTTableViewDelegate *delegate = (TTTableViewDelegate *)tableView.delegate;
	LocalStonesListController *controller = (LocalStonesListController *)delegate.controller;
	
	for(MSStone *stone in [MSLocalStonesManager defaultManager].stones) {
		MSTableLocalStoneItem *item = [MSTableLocalStoneItem itemWithStone:stone];
		item.URL = controller.picker ? @"tt://stone/edit" : @"tt://local_stone/edit";
		[items addObject:item];
	}
	
	self.items = items;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		[[MSLocalStonesManager defaultManager].stones removeObjectAtIndex:indexPath.row];
		[[MSLocalStonesManager defaultManager] save];
		
		[self.items removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		
		TTTableViewDelegate *delegate = (TTTableViewDelegate *)tableView.delegate;
		[[delegate controller] invalidateView];
	}
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[MSTableLocalStoneItem class]]) {
		return [MSTableLocalStoneItemCell class];
	}
	
	return [super tableView:tableView cellClassForObject:object];
}

@end
