//
//  MSMessage.h
//  Manistone
//
//  Created by Eugenio Depalo on 06/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObject.h"
#import "MSUser.h"

@interface MSMessage : MSRemoteObject {
	MSUser *_user;
	NSMutableArray *_recipients;
	NSString *_subject;
	NSString *_text;
	
	BOOL _unread;
}

@property (nonatomic, retain) MSUser *user;
@property (nonatomic, retain) NSMutableArray *recipients;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *text;

@property (nonatomic, assign) BOOL unread;

@end
