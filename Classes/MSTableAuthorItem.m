//
//  MSTableAuthorItem.m
//  Manistone
//
//  Created by Eugenio Depalo on 31/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTableAuthorItem.h"


@implementation MSTableAuthorItem

@synthesize author = _author;

+ (id)itemWithAuthor:(MSUser *)author {
	TTStyle *style = [TTShapeStyle styleWithShape:[TTRectangleShape shape] next:
	 [TTSolidBorderStyle styleWithColor:[UIColor colorWithWhite:0.86 alpha:1]
								  width:1 next:
	  [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 2, 2, 2) next:
	   [TTContentStyle styleWithNext:
		[TTImageStyle styleWithImageURL:nil
						   defaultImage:nil
							contentMode:UIViewContentModeScaleAspectFill
								   size:CGSizeMake(50, 50) next:nil]]]]];
	
	MSTableAuthorItem *item = [self itemWithText:author.fullName
										imageURL:nil
									defaultImage:TTIMAGE(@"bundle://defaultPicture.png")
									  imageStyle:style
											 URL:nil];
	
	item.imageURL = [author remotePhotoURLWithStyle:@"thumb"];
	item.author = author;
	item.URL = [author URLValueWithName:@"show"];
	
	return item;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_author);
	
	[super dealloc];
}

@end
