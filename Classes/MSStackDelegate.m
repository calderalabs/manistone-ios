//
//  MSStackDelegate.m
//  Manistone
//
//  Created by Eugenio Depalo on 27/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStackDelegate.h"
#import "MSStackDataSource.h"
#import "MSStack.h"

@implementation MSStackDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MSStackDataSource *dataSource = (MSStackDataSource *)tableView.dataSource;
	MSStack *stack = (MSStack *)dataSource.remoteObjectModel.remoteObject;
	
	return indexPath.row < stack.stones.count ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	MSStackDataSource *dataSource = (MSStackDataSource *)tableView.dataSource;
	MSStack *stack = (MSStack *)dataSource.remoteObjectModel.remoteObject;
	
	return indexPath.row < stack.stones.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	MSStackDataSource *dataSource = (MSStackDataSource *)tableView.dataSource;
	MSStack *stack = (MSStack *)dataSource.remoteObjectModel.remoteObject;
	
	return proposedDestinationIndexPath.row > stack.stones.count - 1 ? sourceIndexPath : proposedDestinationIndexPath;
}

@end
