//
//  StonesListController.m
//  Manistone
//
//  Created by Eugenio Depalo on 07/09/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "StonesListController.h"
#import "MSStoneListDataSource.h"

#import "MSSearchModel.h"
#import "MSPickerViewCell.h"
#import "MSTag.h"
#import "MSStone.h"
#import "MSStonesSearchModel.h"
#import <Three20/Three20+Additions.h>

@implementation StonesListController

enum {
	kDateOrder = 0,
	kVotesOrder,
	kViewsOrder
};

static CGFloat kHeaderViewHeight = 50;

- (id)initWithTitle:(NSString *)title query:(NSDictionary *)query {
	if(self = [self initWithParameters:[query valueForKey:@"parameters"]]) {
		_customTitle = [title retain];
		_markUnread = [[query valueForKey:@"markUnread"] boolValue];
		_showSort = [[query valueForKey:@"showSort"] boolValue];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_customTitle);
	TT_RELEASE_SAFELY(_relatedTagsView);
	TT_RELEASE_SAFELY(_relatedTagsLabel);
	TT_RELEASE_SAFELY(_cells);
	TT_RELEASE_SAFELY(_emptyRelatedTagsLabel);
	
	[super dealloc];
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
	MSStoneListDataSource *dataSource = (MSStoneListDataSource *)self.dataSource;
	
	MSStonesSearchModel *model = (MSStonesSearchModel *)dataSource.model;
	
	if(model.results.count > 0) {
		if(!self.navigationItem.rightBarButtonItem)
			[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"Map"
																				   style:UIBarButtonItemStylePlain
																				  target:self
																				   action:@selector(showMap:)] autorelease] animated:YES];
	}
	else {
		[self.navigationItem setRightBarButtonItem:nil animated:YES];
	}

	if(_relatedTagsView) {
		for(MSPickerViewCell *cell in _cells)
			[cell removeFromSuperview];
		
		[_cells removeAllObjects];
		
		if(model.relatedTags.count == 0) {
			_emptyRelatedTagsLabel.hidden = NO;
		}
		else {
			_emptyRelatedTagsLabel.hidden = YES;
			
			CGFloat xOffset = 20 + _relatedTagsLabel.right;
			
			for(MSTag *tag in model.relatedTags) {
				MSPickerViewCell *cell = [[MSPickerViewCell alloc] init];
				[_cells addObject:cell];
				
				cell.label = tag.name;
				cell.object = tag;
				[cell addTarget:self action:@selector(tagSelected:) forControlEvents:UIControlEventTouchUpInside];
				[cell sizeToFit];
				
				cell.frame = CGRectMake(xOffset, floor((_relatedTagsView.height - cell.height) / 2), cell.width, cell.height);
				
				xOffset += cell.width + 10;
				
				[_relatedTagsView addSubview:cell];
				
				_relatedTagsView.contentSize = CGSizeMake(cell.right + 10, _relatedTagsView.height);

				TT_RELEASE_SAFELY(cell);
			}
		}
	}
}

- (void)loadView {
	[super loadView];
	
	self.navigationBarTintColor = TTSTYLEVAR(navigationBarTintColor);
	
	self.title = _customTitle;
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TTApplicationFrame().size.width, 0)];
	
	if([_parameters valueForKey:@"tag_name"]) {
		_emptyRelatedTagsLabel = [[UILabel alloc] init];
		_emptyRelatedTagsLabel.text = NSLocalizedString(@"No related tag found", @"");
		_emptyRelatedTagsLabel.backgroundColor = [UIColor clearColor];
		_emptyRelatedTagsLabel.font = [UIFont systemFontOfSize:13];
		[_emptyRelatedTagsLabel sizeToFit];
		_emptyRelatedTagsLabel.hidden = YES;
		
		_cells = [[NSMutableArray alloc] init];
		_relatedTagsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerView.height, headerView.width, kHeaderViewHeight)];
		_relatedTagsView.backgroundColor = TTSTYLEVAR(tableGroupedBackgroundColor);
		
		[_relatedTagsView addSubview:_emptyRelatedTagsLabel];
		
		_relatedTagsLabel = [[UILabel alloc] init];
		_relatedTagsLabel.backgroundColor = [UIColor clearColor];
		_relatedTagsLabel.text = NSLocalizedString(@"Related", @"");
		_relatedTagsLabel.font = [UIFont boldSystemFontOfSize:15];
		[_relatedTagsView addSubview:_relatedTagsLabel];
		[_relatedTagsLabel sizeToFit];
		
		_relatedTagsLabel.frame = CGRectMake(10,
											 floor((_relatedTagsView.height - _relatedTagsLabel.height) / 2),
											 _relatedTagsLabel.width, _relatedTagsLabel.height);
		
		_emptyRelatedTagsLabel.frame = CGRectMake(20 + _relatedTagsLabel.right,
												  floor((_relatedTagsView.height - _emptyRelatedTagsLabel.height) / 2),
												  _emptyRelatedTagsLabel.width,
												  _emptyRelatedTagsLabel.height);
		
		UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(_relatedTagsLabel.right + 10, 0, 1, _relatedTagsView.height)];
		separatorView.backgroundColor = TTSTYLEVAR(messageFieldSeparatorColor);
		[_relatedTagsView addSubview:separatorView];
		
		TT_RELEASE_SAFELY(separatorView);
		
		[headerView addSubview:_relatedTagsView];
		
		headerView.frame = TTRectContract(headerView.frame, 0, -kHeaderViewHeight);
	}

	if(_showSort) {
		UISegmentedControl *order = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
																			   NSLocalizedString(@"Recent", @""),
																			   NSLocalizedString(@"Popular", @""),
																			   NSLocalizedString(@"Viewed", @""),
																			   nil]];
		
		[order addTarget:self action:@selector(orderChanged:) forControlEvents:UIControlEventValueChanged];
		
		order.tintColor = TTSTYLEVAR(controlTintColor);
		order.segmentedControlStyle = UISegmentedControlStyleBar;
		order.selectedSegmentIndex = 0;
		
		CGRect frame = order.frame;
		frame.size.width = headerView.frame.size.width - 40;
		frame.origin.x = 20;
		frame.origin.y = 10 + headerView.bottom;
		
		order.frame = frame;
		
		[headerView addSubview:order];
		TT_RELEASE_SAFELY(order);
		
		headerView.frame = TTRectContract(headerView.frame, 0, -kHeaderViewHeight);
	}
	
	self.tableView.tableHeaderView = headerView;
	
	TT_RELEASE_SAFELY(headerView);
}

- (void)tagSelected:(id)sender {
	MSPickerViewCell *cell = (MSPickerViewCell *)sender;
	MSTag *tag = (MSTag *)cell.object;
	
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:[tag URLValueWithName:@"show"]]
											 applyAnimated:YES]
											applyQuery:[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:tag.name forKey:@"tag_name"] forKey:@"parameters"]]];
}

- (void)showMap:(id)sender {
	MSStoneListDataSource *dataSource = (MSStoneListDataSource *)self.dataSource;
	MSSearchModel *model = (MSSearchModel *)dataSource.model;
	
	[[TTNavigator navigator] openURLAction:[[[[TTURLAction actionWithURLPath:@"tt://stones/map"]
											  applyAnimated:YES]
											 applyTransition:UIViewAnimationTransitionFlipFromLeft]
											applyQuery:[NSDictionary dictionaryWithObject:model.results forKey:@"stones"]]];
}

- (void)orderChanged:(id)sender {
	UISegmentedControl *order = (UISegmentedControl *)sender;
	
	MSStoneListDataSource *dataSource = (MSStoneListDataSource *)self.dataSource;
	MSSearchModel *model = (MSSearchModel *)dataSource.model;
	
	switch (order.selectedSegmentIndex) {
		case kDateOrder:
			[model.parameters setValue:@"date" forKey:@"sort"];
			break;
			
		case kVotesOrder:
			[model.parameters setValue:@"votes" forKey:@"sort"];
			break;
			
		case kViewsOrder:
			[model.parameters setValue:@"views" forKey:@"sort"];
			break;
	}
	
	[self reload];
}


- (void)createModel {
	NSMutableDictionary *completeParameters = [NSMutableDictionary dictionaryWithDictionary:_parameters];
	[completeParameters setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"kStonesPerPage"] forKey:@"per_page"];
	MSStoneListDataSource *dataSource = [[[MSStoneListDataSource alloc] initWithParameters:[NSDictionary dictionaryWithDictionary:completeParameters]] autorelease];
	dataSource.markUnread = _markUnread;
	self.dataSource = dataSource;
}


- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end
