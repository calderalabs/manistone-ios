//
//  MSRemoteObject.h
//  Manistone
//
//  Created by Eugenio Depalo on 13/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSRemoteObject : NSObject <TTURLObject, NSCopying> {
	NSNumber *_uid;
	NSDate *_createdAt;
	NSDate *_updatedAt;
}

@property (nonatomic, retain) NSNumber *uid;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;

@property (nonatomic, readonly) NSDictionary *attributes;

+ (NSString *)collectionName;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
