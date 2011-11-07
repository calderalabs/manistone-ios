//
//  MSStonesSearchDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 11/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStonesSearchDataSource.h"
#import "MSTableViewCell.h"

@implementation MSStonesSearchDataSource

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[TTTableViewItem class]]) {
		return [MSTableViewCell class];
	}
	
	return [super tableView:tableView cellClassForObject:object];
}

@end
