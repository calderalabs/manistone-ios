//
//  MSStoneDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 09/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObjectModel.h"
#import "MSSubItemsDataSource.h"

@class MSTableSubItemsItem;
@class MSTableAuthorItem;

@interface MSStoneDataSource : MSSubItemsDataSource <TTURLRequestDelegate, UIActionSheetDelegate> {
	MSRemoteObjectModel *_remoteObjectModel;
	MSTableSubItemsItem *_detailsItem;
}

@property (nonatomic, retain) MSRemoteObjectModel *remoteObjectModel;

- (id)initWithUid:(NSUInteger)uid;

@end
