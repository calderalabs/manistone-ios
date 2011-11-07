//
//  MSStyledTextCaptionItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 10/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSStyledTextCaptionItem : TTTableStyledTextItem {
	NSString *_caption;
}

@property (nonatomic, retain) NSString *caption;

+ (id)itemWithText:(TTStyledText *)text caption:(NSString *)caption;

@end
