//
//  OverlayWindow.h
//  AutoClick
//
//  Created by 内山　和也 on 平成28/04/18.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol OverlayWindowDelegate
- (void)willGetClickPoint:(CGPoint)point;
- (void)willCloseChildWindow;
@end

@interface OverlayWindow : NSWindow {

	BOOL movingVerticaly;
	id <OverlayWindowDelegate> _del;
}
- (void)setDelegate:(id <OverlayWindowDelegate>)delegate;
@end
