//
//  MSTableDedicationItemCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 15/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSTableDedicationItem.h"

@interface MSTableDedicationItemCell : TTTableTextItemCell {
	MSTableDedicationItem *_item2;
	
	UILabel *_timestampLabel;
	TTStyledTextLabel *_authorLabel;
	TTView *_engravingView;
}

@end
