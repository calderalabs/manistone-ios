//
//  MSListDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 18/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSListDataSource.h"

@implementation MSListDataSource

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSSearchModel alloc] initWithResource:nil parameters:parameters];
}

- (id)initWithParameters:(NSDictionary *)parameters {
	if(self = [self initWithItems:nil]) {
		[self createModelWithParameters:parameters];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_searchModel);
	
	[super dealloc];
}

- (id<TTModel>)model {
	return _searchModel;
}

- (UIImage*)imageForEmpty
{
	return [UIImage imageNamed:@"Three20.bundle/images/empty.png"];
}

- (UIImage*)imageForError:(NSError*)error
{
    return [UIImage imageNamed:@"Three20.bundle/images/error.png"];
}

- (void)search:(NSString*)text {
    [_searchModel search:text];
}

@end
