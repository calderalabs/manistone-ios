//
//  MSTablePicturePickerItemCell.m
//  Manistone
//
//  Created by Eugenio Depalo on 07/11/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSTablePicturePickerItemCell.h"
#import "UIImage+MSAdditions.h"

@implementation MSTablePicturePickerItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		
		_imageView2 = [[TTImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
		_imageView2.defaultImage = TTIMAGE(@"bundle://defaultPicture.png");
		
		_imageView2.style = [TTShapeStyle styleWithShape:[TTRectangleShape shape] next:
							 [TTSolidBorderStyle styleWithColor:[UIColor colorWithWhite:0.86 alpha:1]
														  width:1 next:
							  [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 2, 2, 2) next:
							   [TTContentStyle styleWithNext:
								[TTImageStyle styleWithImageURL:nil
												   defaultImage:nil
													contentMode:UIViewContentModeScaleAspectFill
														   size:CGSizeMake(80, 80) next:nil]]]]];
		
		_localImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_localImageView.backgroundColor = [UIColor clearColor];
		_imageView2.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_imageView2];
		[self.contentView addSubview:_localImageView];
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_localImageView);
	TT_RELEASE_SAFELY(_imageView2);
	TT_RELEASE_SAFELY(_item);
	
	[super dealloc];
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return 100;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	_imageView2.frame = CGRectMake(self.contentView.right - _imageView2.width - 20,
								   floor((self.contentView.height - _imageView2.height) / 2),
								   _imageView2.width,
								   _imageView2.height);
	
	_localImageView.frame = CGRectMake(_imageView2.origin.x + 3, _imageView2.origin.y + 3, _imageView2.width - 6, _imageView2.height - 6);
}

- (id)object {
	return _item;
}

- (void)setObject:(id)object {
	if (object != _item) {
		[super setObject:object];
		
		TT_RELEASE_SAFELY(_item);
		_item = [object retain];
		
		_item.delegate = self;
		_item.selector = @selector(choosePicture:);
		
		self.textLabel.text = _item.text;
		self.textLabel.backgroundColor = [UIColor clearColor];
		
		_imageView2.urlPath = _item.imageURL;
	}
}

- (void)choosePicture:(id)sender {
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
										 destructiveButtonTitle:(_localImageView.image || _item.shouldShowDelete) ? NSLocalizedString(@"Delete photo", @"") : nil
											  otherButtonTitles:NSLocalizedString(@"Take photo", @""), NSLocalizedString(@"Choose photo", @""), nil];
	
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
	
	TT_RELEASE_SAFELY(sheet);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		if(buttonIndex == actionSheet.destructiveButtonIndex) {
			if(_imageView2.urlPath) {
				if([_item.pictureDelegate respondsToSelector:@selector(tablePicturePickerDeleteButtonClicked)])
					[_item.pictureDelegate tablePicturePickerDeleteButtonClicked];
			}
			
			_imageView2.urlPath = nil;
			_localImageView.image = nil;
		}
		else {
			UIImagePickerController * picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.allowsEditing = YES;
			
			if(buttonIndex == actionSheet.firstOtherButtonIndex + 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
				picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				[[TTNavigator navigator].visibleViewController presentModalViewController:picker animated:YES];
			}
			else if(buttonIndex == actionSheet.firstOtherButtonIndex && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
				
				[[TTNavigator navigator].visibleViewController presentModalViewController:picker animated:YES];
			}
			
			TT_RELEASE_SAFELY(picker);
		}
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker.parentViewController dismissModalViewControllerAnimated:YES];
	
	UIImage *image = [(UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"] imageByScalingProportionallyToSize:CGSizeMake(160, 160)];
	
	_localImageView.image = image;
	_imageView2.urlPath = nil;
	
	if([_item.pictureDelegate respondsToSelector:@selector(tablePicturePickerDidPickImage:)])
		[_item.pictureDelegate tablePicturePickerDidPickImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
