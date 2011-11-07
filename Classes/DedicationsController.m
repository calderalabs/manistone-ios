//
//  DedicationsController.m
//  Manistone
//
//  Created by Eugenio Depalo on 05/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "DedicationsController.h"
#import "MSDedicationsDataSource.h"
#import "MSCommentsDelegate.h"

@implementation DedicationsController

- (void)loadView {
	[super loadView];
	
	self.variableHeightRows = YES;
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
	MSDedicationsDataSource *dataSource = (MSDedicationsDataSource *)self.dataSource;
	
	MSSearchModel *model = (MSSearchModel *)dataSource.model;
	
	if(model.results.count > 0) {
		if(!self.navigationItem.rightBarButtonItem)
			[self.navigationItem setRightBarButtonItem:[self editButtonItem] animated:YES];
	}
	else {
		[self.navigationItem setRightBarButtonItem:nil animated:YES];
	}

}

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithParameters:[query valueForKey:@"parameters"]]) {
		self.title = NSLocalizedString(@"Dedications", @"");
	}
	
	return self;
}

- (void)createModel {
	self.dataSource = [[[MSDedicationsDataSource alloc] initWithParameters:nil] autorelease];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[MSCommentsDelegate alloc] initWithController:self] autorelease];
}

@end
