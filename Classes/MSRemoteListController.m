//
//  MSRemoteListController.m
//  Manistone
//
//  Created by Eugenio Depalo on 04/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSRemoteListController.h"
#import "NSNumber+MSAdditions.h"

@implementation MSRemoteListController

- (MSSearchModel *)searchModel {
	return (MSSearchModel *)self.model;
}

- (MSListDataSource *)searchDataSource {
	return (MSListDataSource *)self.dataSource;
}

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	self = [self initWithParameters:[query valueForKey:@"parameters"]];
	
	return self;
}

- (id)initWithParameters:(NSDictionary *)parameters {
	if(self = [self init]) {
		_parameters = [parameters retain];
		
		_nextButton = [[UIBarButtonItem alloc] initWithImage:
					   TTIMAGE(@"bundle://Three20.bundle/images/nextIcon.png")
													   style:UIBarButtonItemStylePlain target:self action:@selector(loadNext)];
		_previousButton = [[UIBarButtonItem alloc] initWithImage:
						   TTIMAGE(@"bundle://Three20.bundle/images/previousIcon.png")
														   style:UIBarButtonItemStylePlain target:self action:@selector(loadPrevious)];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_parameters);
	TT_RELEASE_SAFELY(_nextButton);
	TT_RELEASE_SAFELY(_previousButton);
	TT_RELEASE_SAFELY(_pageLabel);
	TT_RELEASE_SAFELY(_pagingToolbar);
	TT_RELEASE_SAFELY(_pageLabelButton);
	
	[super dealloc];
}

- (void)loadView {
	[super loadView];
	
	_pagingToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.height - TT_TOOLBAR_HEIGHT, self.view.width, TT_TOOLBAR_HEIGHT)];
	_pagingToolbar.tintColor = TTSTYLEVAR(toolbarTintColor);
	
	_pageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_pageLabel.font = [UIFont boldSystemFontOfSize:12];
	_pageLabel.textColor = [UIColor whiteColor];
	[_pageLabel sizeToFit];
	_pageLabel.backgroundColor = [UIColor clearColor];
	
	_pageLabelButton = [[UIBarButtonItem alloc] initWithCustomView:nil];
	
	_pagingToolbar.items = [NSArray arrayWithObjects:_previousButton,
						 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
						 _pageLabelButton,
						 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
						 _nextButton, nil];
	
	[self.view addSubview:_pagingToolbar];
    
	_pagingToolbar.hidden = YES;
}

- (void)createModel {
	self.dataSource = [[[MSListDataSource alloc] initWithParameters:_parameters] autorelease];
}

- (void)showToolbar {
	if(_pagingToolbar.hidden == YES) {
		_pagingToolbar.hidden = NO;
		self.tableView.height -= _pagingToolbar.height;
	}
}

- (void)hideToolbar {
	if(_pagingToolbar.hidden == NO) {
		_pagingToolbar.hidden = YES;
		self.tableView.height += _pagingToolbar.height;
	}
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];

	if(self.searchModel.pages > 1) {
		_pageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Page %u of %u (%@ results)", @""), self.searchModel.page, self.searchModel.pages, [[NSNumber numberWithUnsignedInteger:self.searchModel.count] shortStringValue]];
		[_pageLabel sizeToFit];
		
		_pageLabelButton.customView = _pageLabel;
		
		_previousButton.enabled = (self.searchModel.page > 1);
		_nextButton.enabled = (self.searchModel.page < self.searchModel.pages);
		
		[self showToolbar];
	}
	else {
		[self hideToolbar];
	}
	
}

- (void)disableNavigation {
	_nextButton.enabled = NO;
	_previousButton.enabled = NO;
	
	UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	[activityView startAnimating];
	
	_pageLabelButton.customView = activityView;
}

- (void)loadNext {
	[self.searchModel loadPage:self.searchModel.page + 1];
	[self disableNavigation];
}

- (void)loadPrevious {
	[self.searchModel loadPage:self.searchModel.page - 1];
	[self disableNavigation];
}

@end
