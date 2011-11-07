//
//  MSDedicateModel.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSDedicateModel.h"
#import "MSUser.h"

@implementation MSDedicateModel

- (id)initWithParameters:(NSDictionary *)parameters {
	self = [self initWithResource:[MSUser class] parameters:parameters];
	
	return self;
}

- (BOOL)isLoaded {
	return !TTIsStringWithAnyText([_parameters valueForKey:@"q"]) || [super isLoaded];
}

@end
