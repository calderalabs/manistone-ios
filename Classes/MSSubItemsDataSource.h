//
//  MSSubItemsDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 10/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSSubItemsDataSource : TTListDataSource {
	NSArray *_shownItems;
}

- (void)updateShownItems;

@end
