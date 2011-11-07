//
//  MSTableStackItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 21/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSStack.h"

@interface MSTableStackItem : TTTableLinkedItem {
	MSStack *_stack;
}

@property (nonatomic, retain) MSStack *stack;

+ (id)itemWithStack:(MSStack *)stack;

@end
