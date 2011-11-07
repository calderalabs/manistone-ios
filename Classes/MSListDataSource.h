//
//  MSListDataSource.h
//  Manistone
//
//  Created by Eugenio Depalo on 18/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSSearchModel.h"

@interface MSListDataSource : TTListDataSource {
	MSSearchModel *_searchModel;
}

- (id)initWithParameters:(NSDictionary *)parameters;
- (void)createModelWithParameters:(NSDictionary *)parameters;

@end
