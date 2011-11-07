//
//  MSDedication.h
//  Manistone
//
//  Created by Eugenio Depalo on 15/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSRemoteObject.h"
#import "MSStone.h"
#import "MSUser.h"

@interface MSDedication : MSRemoteObject {
	MSStone *_stone;
	MSUser *_user;
	BOOL _unread;
}

@property (nonatomic, retain) MSStone *stone;
@property (nonatomic, retain) MSUser *user;
@property (nonatomic, assign) BOOL unread;

@end
