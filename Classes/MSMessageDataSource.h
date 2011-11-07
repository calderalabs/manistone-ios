//
//  MSMessageDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 06/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObjectModel.h"

@interface MSMessageDataSource : TTListDataSource {
	MSRemoteObjectModel *_remoteObjectModel;
}

@property (nonatomic, retain) MSRemoteObjectModel *remoteObjectModel;

@end
