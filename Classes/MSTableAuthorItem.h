//
//  MSTableAuthorItem.h
//  Manistone
//
//  Created by Eugenio Depalo on 31/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSUser.h"

@interface MSTableAuthorItem : TTTableImageItem {
	MSUser *_author;
}

@property (nonatomic, retain) MSUser *author;

+ (id)itemWithAuthor:(MSUser *)author;

@end
