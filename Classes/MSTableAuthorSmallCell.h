//
//  MSTableAuthorSmallCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 18/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableAuthorItem.h"

@interface MSTableAuthorSmallCell : TTTableImageItemCell {
	MSTableAuthorItem *_item2;
	TTView *_unreadBadge;
	UILabel *_unreadLabel;
}

@end
