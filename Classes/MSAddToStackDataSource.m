//
//  MSAddToStackDataSource.m
//  Manistone
//
//  Created by Eugenio Depalo on 24/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSAddToStackDataSource.h"
#import "MSTableStackItem.h"
#import "MSTableSelectableItemCell.h"
#import "MSCollectionRequest.h"

@implementation MSAddToStackDataSource

@synthesize delegate = _delegate;

- (NSString *)titleForEmpty {
	return NSLocalizedString(@"Create a stack first", @"");
}

- (NSString *)subtitleForEmpty {
	return NSLocalizedString(@"To create a new stack, tap the add button in the top right corner.", @"");
}

- (UIImage *)imageForEmpty {
	return [UIImage imageNamed:@"stack.png"];
}

- (id)initWithParameters:(NSDictionary *)parameters {
	if(self = [super initWithParameters:parameters]) {
		_uid = [[parameters valueForKey:@"stone_id"] unsignedIntegerValue];
	}
	
	return self;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {	
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for(MSStack* stack in _searchModel.results) {
		TTTableButton *item = [TTTableButton itemWithText:stack.name];
		item.userInfo = stack;
		item.delegate = self;
		item.selector = @selector(stackSelected:);
		
		[items addObject:item];
	}
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {   
    if ([object isKindOfClass:[TTTableButton class]]) {  
        return [MSTableSelectableItemCell class];  
    } else {  
        return [super tableView:tableView cellClassForObject:object];  
    }  
}  

- (void)stackSelected:(id)sender {
	TTTableButton *button = (TTTableButton *)sender;
	MSStack *stack = (MSStack *)button.userInfo;
	
	MSCollectionRequest *request = [[MSCollectionRequest alloc] initWithResource:@"stacked_stones"
										   action:MSCollectionRequestActionCreate parameters:[NSDictionary dictionaryWithObject:
																													   [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:_uid], @"stone_id",
																														[stack.uid description], @"stack_id", nil]
																														 forKey:@"stacked_stone"]
										 delegate:_delegate];
	
	[request send];
	
	TT_RELEASE_SAFELY(request);
}

@end
