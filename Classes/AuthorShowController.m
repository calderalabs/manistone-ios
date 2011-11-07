//
//  AuthorShowController.m
//  Manistone
//
//  Created by Eugenio Depalo on 01/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "AuthorShowController.h"
#import "MSAuthorDataSource.h"

#import "MSUser.h"
#import "NSNumber+MSAdditions.h"
#import "NSDate+MSAdditions.h"
#import "MSTableViewSubItemsDelegate.h"

@implementation AuthorShowController

- (id)initWithUid:(NSUInteger)uid {
	if(self = [self init]) {
		_uid = uid;
		
		self.tableViewStyle = UITableViewStyleGrouped;
	}
	
	return self;
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
	
	MSAuthorDataSource *dataSource = (MSAuthorDataSource *)self.dataSource;
	
	MSUser *user = (MSUser *)dataSource.remoteObjectModel.remoteObject;
	
	self.title = user.fullName;
	
	[_pictureView unsetImage];
	_pictureView.urlPath = [user remotePhotoURLWithStyle:@"normal"];
	
	_stonesLabel.text = [TTStyledText textFromXHTML:
						 [NSString stringWithFormat:NSLocalizedString(@"<b>%@</b> stones", @"Number of stones in author profile"), [user.stonesCount shortStringValue]]];
	_followersLabel.text = [TTStyledText textFromXHTML:
							[NSString stringWithFormat:NSLocalizedString(@"<b>%@</b> followers", @"Number of followers in author profile"), [user.followersCount shortStringValue]]];
	_registeredLabel.text = [TTStyledText textFromXHTML:
							 [NSString stringWithFormat:NSLocalizedString(@"<b>Registered:</b> %@", @"Registration date in author profile"), [user.createdAt description]]];
	
	if(user.birthday) {
		_ageLabel.text = [TTStyledText textFromXHTML:
						  [NSString stringWithFormat:NSLocalizedString(@"<b>Age:</b> %d", @"Age of author in profile"), [user.birthday age]]];
		_ageLabel.hidden = NO;
	}
	else {
		_ageLabel.hidden = YES;
	}
	
	if(TTIsStringWithAnyText(user.hometown)) {
		_locationLabel.text = [TTStyledText textFromXHTML:
							   [NSString stringWithFormat:NSLocalizedString(@"<b>Hometown:</b> %@", @""), user.hometown]];
		
		_locationLabel.hidden = NO;
	}
	else {
		_locationLabel.hidden = YES;
	}
}

- (void)loadView {
	[super loadView];
	
	TTImageStyle *imageStyle = [TTImageStyle styleWithImageURL:nil
												  defaultImage:nil
												   contentMode:UIViewContentModeScaleAspectFill
														  size:CGSizeMake(90, 90) next:nil];
	
	TTStyle *style = [TTShapeStyle styleWithShape:[TTRectangleShape shape] next:
					  [TTSolidBorderStyle styleWithColor:[UIColor colorWithWhite:0.86 alpha:1]
												   width:1 next:
					   [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 2, 2, 2) next:
						[TTContentStyle styleWithNext:
						 imageStyle]]]];
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 110)];
	headerView.backgroundColor = TTSTYLEVAR(controlTintColor);
	
	UIView *headerContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, headerView.width - 10, headerView.height - 10)];
	
	[headerView addSubview:headerContentView];
	
	_pictureView = [[TTImageView alloc] init];
	_pictureView.style = style;
	_pictureView.defaultImage = TTIMAGE(@"bundle://defaultPicture.png");
	_pictureView.urlPath = @"";
	_pictureView.contentMode = imageStyle.contentMode;
	_pictureView.clipsToBounds = YES;
	_pictureView.backgroundColor = [UIColor clearColor];
	
	_pictureView.frame = CGRectMake(0, 0,
									imageStyle.size.width, imageStyle.size.width);
	
	[headerContentView addSubview:_pictureView];
	
	UIView *detailsView = [[UIView alloc] initWithFrame:CGRectMake(_pictureView.right + 15,
																   0,
																   headerContentView.width - _pictureView.right - 5,
																   headerContentView.height)];
	
	[headerContentView addSubview:detailsView];
	
	_stonesLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, detailsView.width, 17)];
	_stonesLabel.backgroundColor = [UIColor clearColor];
	_stonesLabel.textColor = [UIColor whiteColor];
	[detailsView addSubview:_stonesLabel];
	
	_followersLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, _stonesLabel.bottom, detailsView.width, 17)];
	_followersLabel.backgroundColor = [UIColor clearColor];
	_followersLabel.textColor = [UIColor whiteColor];
	[detailsView addSubview:_followersLabel];
	
	_registeredLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, _followersLabel.bottom, detailsView.width, 17)];
	_registeredLabel.backgroundColor = [UIColor clearColor];
	_registeredLabel.textColor = [UIColor whiteColor];
	[detailsView addSubview:_registeredLabel];
	
	_ageLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, _registeredLabel.bottom, detailsView.width, 17)];
	_ageLabel.backgroundColor = [UIColor clearColor];
	_ageLabel.textColor = [UIColor whiteColor];
	[detailsView addSubview:_ageLabel];
	
	_locationLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, _ageLabel.bottom, detailsView.width, 17)];
	_locationLabel.backgroundColor = [UIColor clearColor];
	_locationLabel.textColor = [UIColor whiteColor];
	[detailsView addSubview:_locationLabel];
	
	TT_RELEASE_SAFELY(detailsView);
	TT_RELEASE_SAFELY(headerContentView);
	
	self.tableView.tableHeaderView = headerView;
	
	TT_RELEASE_SAFELY(headerView);	
	
	self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_pictureView);
	TT_RELEASE_SAFELY(_stonesLabel);
	TT_RELEASE_SAFELY(_followersLabel);
	TT_RELEASE_SAFELY(_registeredLabel);
	TT_RELEASE_SAFELY(_ageLabel);
	TT_RELEASE_SAFELY(_locationLabel);
	
	[super dealloc];
}


- (id<UITableViewDelegate>)createDelegate {
	return [[[MSTableViewSubItemsDelegate alloc] initWithController:self] autorelease];
}


- (void)createModel {
	self.dataSource = [[[MSAuthorDataSource alloc] initWithUid:_uid] autorelease];
}

@end
