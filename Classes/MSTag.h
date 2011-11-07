//
//  MSTag.h
//  Manistone
//
//  Created by Eugenio Depalo on 16/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSTag : NSObject {
	NSString *_name;
	NSNumber *_count;
}

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name count:(NSNumber *)count;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *count;

+ (NSString *)tagListWithTags:(NSArray *)tags;
+ (NSString *)styledTagListWithTags:(NSArray *)tags;

@end
