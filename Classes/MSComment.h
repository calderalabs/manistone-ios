//
//  MSComment.h
//  Manistone
//
//  Created by Eugenio Depalo on 28/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSRemoteObject.h"
#import "MSUser.h"

@interface MSComment : MSRemoteObject {
	MSUser *_user;
	MSRemoteObject *_resource;
	NSString *_resourceType;
	NSString *_text;
}

@property (nonatomic, retain) MSRemoteObject *resource;
@property (nonatomic, retain) NSString *resourceType;
@property (nonatomic, retain) MSUser *user;
@property (nonatomic, retain) NSString *text;


@end
