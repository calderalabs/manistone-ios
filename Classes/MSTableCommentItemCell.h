//
//  MSTableCommentItemCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 13/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSTableCommentItem.h"

@interface MSTableCommentItemCell : TTTableTextItemCell {
	MSTableCommentItem *_item2;
	
	UILabel *_timestampLabel;
	TTStyledTextLabel *_authorLabel;
}

@end
