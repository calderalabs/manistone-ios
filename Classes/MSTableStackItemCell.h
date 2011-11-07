//
//  MSTableStackItemCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 21/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableStackItem.h"

@interface MSTableStackItemCell : TTTableViewCell {
	MSTableStackItem *_item;
	
	UILabel *_stonesCountLabel;
	TTStyledTextLabel *_dateLabel;
	TTView *_votesView;
	TTStyledTextLabel *_likeLabel;
	TTStyledTextLabel *_dislikeLabel;
	TTStyledTextLabel *_authorLabel;
	TTStyledTextLabel *_commentsLabel;
	TTStyledTextLabel *_viewsLabel;
}

@end
