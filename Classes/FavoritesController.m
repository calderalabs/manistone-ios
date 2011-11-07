//
//  FavoritesController.m
//  Manistone
//
//  Created by Eugenio Depalo on 04/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "FavoritesController.h"
#import "MSFavoritesDataSource.h"

@implementation FavoritesController

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self init]) {
		_uid = uid;
		self.title = NSLocalizedString(@"Favorites", @"");
		self.tableViewStyle = UITableViewStyleGrouped;
	}
	
	return self;
}

- (void)createModel {
	self.dataSource = [[[MSFavoritesDataSource alloc] initWithUid:_uid] autorelease];
}

@end
