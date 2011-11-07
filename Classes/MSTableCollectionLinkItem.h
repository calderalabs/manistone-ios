//
//  MSTableCollectionLinkItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 03/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSTableCollectionLinkItem : TTTableLink {
	NSString *_imageURL;
	NSUInteger _count;
}

@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, assign) NSUInteger count;

+ (id)itemWithText:(NSString *)text imageURL:(NSString *)imageURL count:(NSUInteger)count userInfo:(NSDictionary *)userInfo;
+ (id)itemWithText:(NSString *)text imageURL:(NSString *)imageURL count:(NSUInteger)count URL:(NSString *)URL userInfo:(NSDictionary *)userInfo;
+ (id)itemWithText:(NSString *)text imageURL:(NSString *)imageURL count:(NSUInteger)count URL:(NSString *)URL accessoryURL:(NSString *)accessoryURL userInfo:(NSDictionary *)userInfo;

@end
