//
//  MSStone.h
//  Manistone
//
//  Created by Eugenio Depalo on 07/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObject.h"
#import "MSUser.h"
#import "MSTag.h"

@interface MSStone : MSRemoteObject <MKAnnotation, NSCoding> {
	MSUser *_user;
	
	NSMutableArray *_tags;

	NSNumber *_likesCount;
	NSNumber *_dislikesCount;
	NSNumber *_viewsCount;
	NSNumber *_commentsCount;
	NSNumber *_stacksCount;
	
	NSString *_engraving;
	CLLocationCoordinate2D _location;
	
	BOOL _favorited;
	BOOL _liked;
	BOOL _disliked;
	BOOL _viewed;
	BOOL _flagged;
	BOOL _unread;
}

@property (nonatomic, retain) MSUser *user;

@property (nonatomic, retain) NSMutableArray *tags;

@property (nonatomic, retain) NSNumber *likesCount;
@property (nonatomic, retain) NSNumber *dislikesCount;
@property (nonatomic, retain) NSNumber *viewsCount;
@property (nonatomic, retain) NSNumber *commentsCount;
@property (nonatomic, retain) NSNumber *stacksCount;

@property (nonatomic, retain) NSString *engraving;
@property (nonatomic, assign) CLLocationCoordinate2D location;

@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL disliked;
@property (nonatomic, assign) BOOL viewed;
@property (nonatomic, assign) BOOL flagged;
@property (nonatomic, assign) BOOL unread;

@end
