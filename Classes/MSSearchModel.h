//
//  MSSearchModel.h
//  Manistone
//
//  Created by Eugenio Depalo on 08/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSResourceModel.h"

@interface MSSearchModel : MSResourceModel {
	NSString *_collectionName;
	NSMutableDictionary *_parameters;
	NSMutableArray *_results;
	NSUInteger _count;
	NSUInteger _page;
	NSUInteger _pages;
}

@property (nonatomic, retain) NSMutableDictionary *parameters;
@property (nonatomic, readonly) NSMutableArray *results;
@property (nonatomic, readonly, assign) NSUInteger count;
@property (nonatomic, readonly, assign) NSUInteger page;
@property (nonatomic, readonly, assign) NSUInteger pages;

- (id)initWithResource:(Class)resource parameters:(NSDictionary *)parameters;
- (id)initWithResource:(Class)resource collectionName:(NSString *)collectionName parameters:(NSDictionary *)parameters;

- (void)search:(NSString*)text;
- (void)loadPage:(NSUInteger)page;

@end
