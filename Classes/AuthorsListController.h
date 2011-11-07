//
//  AuthorsListController.h
//  Manistone
//
//  Created by Eugenio Depalo on 30/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSAdController.h"

@interface AuthorsListController : MSAdController <UISearchBarDelegate> {
	BOOL _showSort;
	BOOL _showSearch;
}

@end
