//
//  MSStoneListDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 08/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSListDataSource.h"

@interface MSStoneListDataSource : MSListDataSource {
	BOOL _markUnread;
}

@property (nonatomic, assign) BOOL markUnread;

@end
