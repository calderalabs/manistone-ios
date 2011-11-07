//
//  TagShowController.m
//  Manistone
//
//  Created by Eugenio Depalo on 10/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "TagShowController.h"

@implementation TagShowController

- (id)initWithTagName:(NSString *)tagName {
	self = [self initWithTitle:tagName
						 query:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:tagName forKey:@"tag_name"]
														   forKey:@"parameters"]];
	
	return self;
}

@end
