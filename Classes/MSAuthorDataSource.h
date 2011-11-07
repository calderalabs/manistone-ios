//
//  MSAuthorDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 01/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObjectModel.h"
#import "MSSubItemsDataSource.h"

@class MSTableSubItemsItem;

@interface MSAuthorDataSource : MSSubItemsDataSource <UIAlertViewDelegate> {
	MSRemoteObjectModel *_remoteObjectModel;
	MSTableSubItemsItem	*_detailsItem;
}

@property (nonatomic, retain) MSRemoteObjectModel *remoteObjectModel;

- (id)initWithUid:(NSUInteger)uid;
- (id)initWithUid:(NSUInteger)uid parameters:(NSDictionary *)parameters;

@end
