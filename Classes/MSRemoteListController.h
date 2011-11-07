//
//  MSRemoteListController.h
//  Manistone
//
//  Created by Eugenio Depalo on 04/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSSearchModel.h"
#import "MSListDataSource.h"

@interface MSRemoteListController : TTTableViewController {
	NSDictionary *_parameters;
	UIToolbar *_pagingToolbar;
	UIBarButtonItem *_nextButton;
	UIBarButtonItem *_previousButton;
	UIBarButtonItem *_pageLabelButton;
	UILabel *_pageLabel;
}

- (id)initWithParameters:(NSDictionary *)parameters;

@property (nonatomic, readonly) MSSearchModel *searchModel;
@property (nonatomic, readonly) MSListDataSource *searchDataSource;

@end
