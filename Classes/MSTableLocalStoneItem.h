//
//  MSTableLocalStoneItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 12/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSStone.h"

@interface MSTableLocalStoneItem : TTTableTextItem {
	MSStone *_stone;
}

@property (nonatomic, retain) MSStone *stone;

+ (id)itemWithStone:(MSStone *)stone;

@end
