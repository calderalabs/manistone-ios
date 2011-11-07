//
//  MSTableAuthorItemCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 31/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableAuthorItem.h"

@interface MSTableAuthorItemCell : TTTableImageItemCell {
	MSTableAuthorItem *_item2;
	
	TTStyledTextLabel *_stonesLabel;
	TTStyledTextLabel *_followersLabel;
	TTStyledTextLabel *_locationLabel;
}

@end
