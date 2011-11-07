//
//  MSDefaultStyleSheet.m
//  Manistone
//
//  Created by Eugenio Depalo on 13/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSDefaultStyleSheet.h"

@interface TTDefaultStyleSheet (MSAdditions)
    
- (TTStyle *)pickerCell:(UIControlState)state;

@end

@implementation MSDefaultStyleSheet

- (UIFont *)tableDetailsFont {
	return [UIFont systemFontOfSize:11];
}

- (UIColor *)controlTintColor {
	return RGBCOLOR(121, 57, 14);
}

- (UIColor*)tablePlainBackgroundColor {
	return RGBCOLOR(255, 255, 255);
}

- (UIColor*)tableGroupedBackgroundColor {
	return RGBCOLOR(230, 230, 230);
}

- (UIColor *)moreLinkTextColor {
	return RGBCOLOR(121, 57, 14);
}

- (UIColor *)linkTextColor {
	return RGBCOLOR(121, 57, 14);
}

- (UIColor *)navigationBarTintColor {
	return RGBCOLOR(241, 147, 0);
}

- (UIColor *)toolbarTintColor {
	return RGBCOLOR(241, 147, 0);
}

- (TTStyle*)launcherButton:(UIControlState)state {
	return
    [TTPartStyle styleWithName:@"image" style:TTSTYLESTATE(launcherButtonImage:, state) next:
	 [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:15] color:RGBCOLOR(0, 0, 0)
				minimumFontSize:12 shadowColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]
				   shadowOffset:CGSizeMake(2, 2) next:nil]];
}

- (TTStyle*)launcherButtonImage:(UIControlState)state {
	TTStyle* style =
    [TTShadowStyle styleWithColor:[self toolbarTintColor] blur:10 offset:CGSizeMake(0, 0) next:[TTBoxStyle styleWithMargin:UIEdgeInsetsMake(-7, 0, 11, 0) next:
                                                                                                [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:0] next:
                                                                                                 [TTImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeCenter
                                                                                                                            size:CGSizeMake(0, 60) next:nil]]]];
	
	if (state == UIControlStateHighlighted || state == UIControlStateSelected) {
		[style addStyle:
		 [TTBlendStyle styleWithBlend:kCGBlendModeSourceAtop next:
		  [TTSolidFillStyle styleWithColor:RGBACOLOR(0,0,0,0.5) next:nil]]];
	}
	
	return style;
}

- (TTStyle *)pickerCell:(UIControlState)state {
	if(state & UIControlStateHighlighted)
		return [super pickerCell:UIControlStateSelected];
	else
		return [super pickerCell:state];
}

@end
