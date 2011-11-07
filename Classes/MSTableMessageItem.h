//
//  MSTableMessageItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSMessage.h"

@interface MSTableMessageItem : TTTableMessageItem {
	MSMessage *_message;
}

@property (nonatomic, retain) MSMessage *message;

+ (id)itemWithMessage:(MSMessage *)message;


@end
