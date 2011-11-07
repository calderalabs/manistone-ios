//
//  MSTableLocalStoneItemCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 12/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSTableLocalStoneItem.h"

@interface MSTableLocalStoneItemCell : TTTableViewCell {
	MSTableLocalStoneItem *_item;
	
	TTView *_engravingView;
	UILabel *_dateLabel;
}

@end
