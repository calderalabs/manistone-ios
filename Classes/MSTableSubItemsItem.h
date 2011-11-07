//
//  MSTableSubItemsItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 10/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSTableSubItemsItem : TTTableTextItem {
	NSArray *_subItems;
	BOOL _shown;
	NSString *_imageURL;
}

@property (nonatomic, retain) NSArray *subItems;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, retain) NSString *imageURL;

+ (id)itemWithText:(NSString*)text subItems:(NSArray *)subItems;
+ (id)itemWithText:(NSString*)text subItems:(NSArray *)subItems imageURL:(NSString *)imageURL;

@end
