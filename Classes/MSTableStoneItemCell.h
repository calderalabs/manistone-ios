//
//  MSTableStoneItemCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableStoneItem.h"

@interface MSTableStoneItemCell : TTTableViewCell {
	MSTableStoneItem *_item;
	
	UIView *_innerView;
	TTView *_engravingView;
	TTStyledTextLabel *_dateLabel;
	TTView *_votesView;
	TTStyledTextLabel *_likeLabel;
	TTStyledTextLabel *_dislikeLabel;
	TTStyledTextLabel *_authorLabel;
	TTStyledTextLabel *_commentsLabel;
	TTStyledTextLabel *_viewsLabel;
}

@end
