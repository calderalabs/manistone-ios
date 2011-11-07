//
//  CommentsController.m
//  Manistone
//
//  Created by Eugenio Depalo on 28/10/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "CommentsController.h"
#import "MSCollectionRequest.h"
#import "MSCommentsListDataSource.h"
#import "MSComment.h"
#import "MSCommentsDelegate.h"

@implementation CommentsController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if(self = [self initWithParameters:[query valueForKey:@"parameters"]]) {
		self.title = NSLocalizedString(@"Comments", @"");
		
		self.variableHeightRows = YES;
		
		if([_parameters valueForKey:@"resource_id"]) {
			self.tableView.allowsSelection = NO;
			
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																								   target:self
																								   action:@selector(add:)];
		}
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	self.editing = YES;
	self.tableView.allowsSelectionDuringEditing = YES;
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[MSCommentsDelegate alloc] initWithController:self] autorelease];
}

- (void)createModel {
	self.dataSource = [[[MSCommentsListDataSource alloc] initWithParameters:_parameters] autorelease];
}

- (BOOL)postController:(TTPostController *)postController willPostText:(NSString *)text {
	MSComment *comment = [[MSComment alloc] init];
	comment.text = text;
	
	NSMutableDictionary *attributes = [[comment attributes] mutableCopy];
	
	TT_RELEASE_SAFELY(comment);
	
	[attributes setValue:[_parameters valueForKey:@"resource_id"] forKey:@"resource_id"];
	[attributes setValue:[_parameters valueForKey:@"resource_type"] forKey:@"resource_type"];
	
	MSCollectionRequest *request = [[MSCollectionRequest alloc] initWithResource:@"comments"
																		  action:MSCollectionRequestActionCreate
																	  parameters:[NSDictionary dictionaryWithObject:attributes forKey:@"comment"]
																		delegate:self];
	
	[request send];
	
	TT_RELEASE_SAFELY(attributes);
	TT_RELEASE_SAFELY(request);
	
	return YES;
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	[self stopActivity];
	
	[self reload];
}

- (void)add:(id)sender {
	TTPostController *commentController = [[TTPostController alloc] init];
	commentController.delegate = self;
	commentController.title = @"Create Comment";
	[commentController showInView:self.view animated:YES];
	
	TT_RELEASE_SAFELY(commentController);
}

@end