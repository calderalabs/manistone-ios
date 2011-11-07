//
//  MSResourceModel.m
//  Manistone
//
//  Created by Eugenio Depalo on 08/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSResourceModel.h"

@implementation MSResourceModel

- (id)initWithResource:(Class)resource {
	if(self = [self init]) {
		_resource = resource;
	}
	
	return self;
}

@end
