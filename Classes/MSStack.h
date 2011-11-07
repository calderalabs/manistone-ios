//
//  MSStack.h
//  Manistone
//
//  Created by Eugenio Depalo on 21/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObject.h"
#import "MSStone.h"

@interface MSStack : MSRemoteObject {
	MSUser *_user;
	NSMutableArray *_stones;
	
	NSNumber *_likesCount;
	NSNumber *_dislikesCount;
	NSNumber *_viewsCount;
	NSNumber *_commentsCount;
	
	NSNumber *_stonesCount;
	
	NSString *_name;
	
	BOOL _favorited;
	BOOL _liked;
	BOOL _disliked;
	BOOL _viewed;
}

@property (nonatomic, retain) MSUser *user;
@property (nonatomic, retain) NSMutableArray *stones;

@property (nonatomic, retain) NSNumber *likesCount;
@property (nonatomic, retain) NSNumber *dislikesCount;
@property (nonatomic, retain) NSNumber *viewsCount;
@property (nonatomic, retain) NSNumber *commentsCount;

@property (nonatomic, retain) NSNumber *stonesCount;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL disliked;
@property (nonatomic, assign) BOOL viewed;

@end
