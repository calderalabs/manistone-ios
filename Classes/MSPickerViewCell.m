//
//  MSPickerViewCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 29/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSPickerViewCell.h"

static const CGFloat kPaddingX = 8;
static const CGFloat kPaddingY = 3;
static const CGFloat kMaxWidth = 250;

@implementation MSPickerViewCell

@synthesize object    = _object;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setStylesWithSelector:@"pickerCell:"];
		
		_labelView = [[UILabel alloc] init];
		_labelView.backgroundColor = [UIColor clearColor];
		_labelView.textColor = TTSTYLEVAR(textColor);
		_labelView.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
		_labelView.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_labelView];
		
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	TT_RELEASE_SAFELY(_object);
	TT_RELEASE_SAFELY(_labelView);
	
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
	_labelView.frame = CGRectMake(kPaddingX, kPaddingY,
								  self.frame.size.width-kPaddingX*2, self.frame.size.height-kPaddingY*2);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)sizeThatFits:(CGSize)size {
	CGSize labelSize = [_labelView.text sizeWithFont:_labelView.font];
	CGFloat width = labelSize.width + kPaddingX*2;
	return CGSizeMake(width > kMaxWidth ? kMaxWidth : width, labelSize.height + kPaddingY*2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)label {
	return _labelView.text;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLabel:(NSString*)label {
	_labelView.text = label;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)font {
	return _labelView.font;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFont:(UIFont*)font {
	_labelView.font = font;
}

@end
