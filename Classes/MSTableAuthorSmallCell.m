//
//  MSTableAuthorSmallCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 18/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableAuthorSmallCell.h"

@implementation MSTableAuthorSmallCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return TT_ROW_HEIGHT;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	_imageView2.frame = CGRectMake(kTableCellMargin,
								   floor((self.contentView.height - 27) / 2), 27, 27);
	
	self.textLabel.frame = CGRectMake(_imageView2.right + kTableCellHPadding,
									  floor((self.contentView.height - self.textLabel.height) / 2),
									  self.textLabel.width,
									  self.textLabel.height);
}

- (id)object {
	return _item2;
}

- (void)setObject:(id)object {
	if (_item2 != object) {
		[super setObject:object];
		
		TT_RELEASE_SAFELY(_item2);
		_item2 = [object retain];
		
		self.textLabel.text = _item2.author.fullName;
		
		_imageView2.style = [TTImageStyle styleWithImageURL:nil
											   defaultImage:nil
												contentMode:UIViewContentModeScaleAspectFill
													   size:CGSizeMake(27, 27) next:nil];
    }
}

@end
