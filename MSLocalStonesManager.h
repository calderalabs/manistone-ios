//
//  MSLocalStonesManager.h
//  Manistone
//
//  Created by Eugenio Depalo on 11/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

@interface MSLocalStonesManager : NSObject {
	NSMutableArray *_stones;
}

+ (MSLocalStonesManager *)defaultManager;

@property (nonatomic, readonly, retain) NSMutableArray *stones;

- (BOOL)save;
- (void)read;

@end
