//
//  StonesListController.h
//  Manistone
//
//  Created by Eugenio Depalo on 07/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSAdController.h"

@interface StonesListController : MSAdController {
	NSString *_customTitle;
	
	UIScrollView *_relatedTagsView;
	UILabel *_relatedTagsLabel;
	NSMutableArray *_cells;
	UILabel *_emptyRelatedTagsLabel;
	
	BOOL _markUnread;
	BOOL _showSort;
}

- (id)initWithTitle:(NSString *)title query:(NSDictionary *)query;

@end
