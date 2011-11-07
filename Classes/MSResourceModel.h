//
//  MSResourceModel.h
//  Manistone
//
//  Created by Eugenio Depalo on 08/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

@interface MSResourceModel : TTURLRequestModel {
	Class _resource;
}

- (id)initWithResource:(Class)resource;

@end
