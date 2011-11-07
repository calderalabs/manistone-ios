//
//  MSTagsDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 16/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTagsDataSource.h"
#import "MSTag.h"

@implementation MSTagsDataSource

- (id)init {
    if (self = [super init]) {
        _tagsModel = [[MSTagsModel alloc] init];
    }
    return self;
}

- (id<TTModel>)model {
	return _tagsModel;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_tagsModel);
	
    [super dealloc];
}

#pragma mark -
#pragma mark TTTableViewDataSource methods

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	for(MSTag *tag in _tagsModel.tags) {
		TTTableTextItem *item = [TTTableTextItem itemWithText:(!tag.count ? tag.name : [NSString stringWithFormat:@"%@ (%@)", tag.name, tag.count])];
		item.userInfo = tag;
		[items addObject:item];
	}
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (void)search:(NSString*)text {
    [_tagsModel search:text];
}

@end
