//
//  MSStonesSearchModel.h
//  Manistone
//
//  Created by Eugenio Depalo on 30/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSSearchModel.h"

@interface MSStonesSearchModel : MSSearchModel {
	NSArray *_relatedStones;
	NSArray *_relatedTags;
}

@property (nonatomic, retain) NSArray *relatedStones;
@property (nonatomic, retain) NSArray *relatedTags;

- (id)initWithParameters:(NSDictionary *)parameters;

@end
