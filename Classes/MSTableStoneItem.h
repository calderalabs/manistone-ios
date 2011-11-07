//
//  MSTableStoneItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStone.h"

@interface MSTableStoneItem : TTTableLinkedItem {
	MSStone *_stone;
	
	BOOL markUnread;
}

@property (nonatomic, retain) MSStone *stone;
@property (nonatomic, assign) BOOL markUnread;

+ (id)itemWithStone:(MSStone *)stone;

@end
