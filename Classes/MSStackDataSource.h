//
//  MSStackDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 26/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSSubItemsDataSource.h"
#import "MSRemoteObjectModel.h"

@class MSTableSubItemsItem;
@class MSTableAuthorItem;

@interface MSStackDataSource : MSSubItemsDataSource <TTURLRequestDelegate, UIActionSheetDelegate> {
	MSRemoteObjectModel *_remoteObjectModel;
	MSTableSubItemsItem *_detailsItem;
}

@property (nonatomic, retain) MSRemoteObjectModel *remoteObjectModel;

- (id)initWithUid:(NSUInteger)uid;

@end
