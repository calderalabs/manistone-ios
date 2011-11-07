//
//  MSTableCommentItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 13/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSComment.h"

@interface MSTableCommentItem : TTTableTextItem {
	MSComment *_comment;
}

@property (nonatomic, retain) MSComment *comment;

+ (id)itemWithComment:(MSComment *)comment;

@end
