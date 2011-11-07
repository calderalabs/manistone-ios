//
//  MSCircleView.m
//  Manistone
//
//  Created by Eugenio Depalo on 19/07/10.
//  Copyright 2010 Lucido Inc. All rights reserved.
//

#import "MSCircleView.h"

@implementation MSCircleView

- (void)createPath {
	[super createPath];
	
	CGMutablePathRef circle = CGPathCreateMutable();
	
	CGPoint center = [self pointForMapPoint:MKMapPointForCoordinate(self.circle.coordinate)];
	
	CGPathAddEllipseInRect(circle, NULL, CGRectMake(center.x - computedRadius,
													center.y - computedRadius,
													computedRadius * 2,
													computedRadius * 2));
	
	self.path = circle;
	
	CGPathRelease(circle);
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
	CGFloat newComputedRadius = self.circle.radius / zoomScale;
	
	if(newComputedRadius != computedRadius) {
		computedRadius = newComputedRadius;
		[self invalidatePath];
	}
	
	[super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
}

@end
