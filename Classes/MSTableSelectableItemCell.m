//
//  MSTableSelectableItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 05/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableSelectableItemCell.h"

@implementation MSTableSelectableItemCell

- (void)setObject:(id)object {
	if (_item != object) {
		[super setObject:object];
		
		self.textLabel.font = TTSTYLEVAR(tableFont);
		self.textLabel.textColor = TTSTYLEVAR(linkTextColor);
		self.textLabel.textAlignment = UITextAlignmentLeft;
	}
}

@end
