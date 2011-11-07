//
//  MSTableSubItemsCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 10/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSTableSubItemsCell : TTTableTextItemCell {
	UIImageView *_arrowView;
}

@property (nonatomic, readonly) UIImageView *arrowView;

- (void)toggleShown;

@end
