//
//  MSTableViewCell.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSTableViewCell : TTTableViewCell {
	TTTableViewItem*  _item;
	UIView*           _view;
}

@property (nonatomic, readonly, retain) TTTableViewItem*  item;
@property (nonatomic, readonly, retain) UIView*           view;

@end
