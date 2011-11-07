//
//  MSDedicateDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 06/01/11.
//  Copyright 2011 Lucido Inc. All rights reserved.
//

#import "MSDedicateDataSource.h"
#import "MSTableAuthorItemCell.h"
#import "MSDedicateModel.h"

@implementation MSDedicateDataSource

- (void)createModelWithParameters:(NSDictionary *)parameters {
	_searchModel = [[MSDedicateModel alloc] initWithParameters:parameters];
}

- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell
willAppearAtIndexPath:(NSIndexPath*)indexPath {
	MSTableAuthorItemCell *authorCell = (MSTableAuthorItemCell *)cell;
	
	authorCell.accessoryType = UITableViewCellAccessoryNone;
}

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"Let this stone fly", @"");
}

- (NSString *)subtitleForEmpty {
	return NSLocalizedString(@"Use the search bar above to search the author you want to dedicate this stone to.", @"");
}

- (UIImage*)imageForEmpty
{
	return [UIImage imageNamed:@"dedications.png"];
}

@end
