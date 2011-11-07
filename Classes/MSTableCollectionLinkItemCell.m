//
//  MSTableCollectionLinkItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 03/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableCollectionLinkItemCell.h"

@implementation MSTableCollectionLinkItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self.textLabel.font = TTSTYLEVAR(tableFont);
		self.textLabel.textColor = TTSTYLEVAR(linkTextColor);
		self.textLabel.textAlignment = UITextAlignmentLeft;
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_item2);
	
	[super dealloc];
}

- (id)object {
	return _item2;
}

- (void)setObject:(id)object {
	if (_item2 != object) {
		[super setObject:object];
		
		TT_RELEASE_SAFELY(_item2);
		_item2 = [object retain];
		
		self.textLabel.text = _item2.text;
		self.imageView.image = [UIImage imageNamed:_item2.imageURL];
		self.detailTextLabel.text = [NSString stringWithFormat:@"%lu", _item2.count];
    }
}

@end
