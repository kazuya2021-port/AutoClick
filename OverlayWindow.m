//
//  OverlayWindow.m
//  AutoClick
//
//  Created by 内山　和也 on 平成28/04/18.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import "OverlayWindow.h"
#import <Carbon/Carbon.h>

@implementation OverlayWindow
-(BOOL)canBecomeKeyWindow{return YES;}
-(BOOL)canBecomeMainWindow{return YES;}

- (void)setDelegate:(id <OverlayWindowDelegate>)delegate 
{
	_del = delegate;
}

-(id)initWithContentRect:(NSRect)contenRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	self = [super initWithContentRect:contenRect styleMask:aStyle backing:bufferingType defer:flag];
	
	if(self)
	{
		[self setOpaque:NO];
		[self setBackgroundColor:[NSColor redColor]];
		[self setHasShadow:YES];
		[self setLevel:NSFloatingWindowLevel];
		[self setAlphaValue:0.3];
		[self setAcceptsMouseMovedEvents:YES];
		[self makeKeyAndOrderFront:nil];

	}
	return self;
}

- (void)keyDown:(NSEvent*)theEvent
{
	// keyCode = 111 => F12
	CGEventRef mouse = CGEventCreate(NULL);
	CGPoint point = CGEventGetLocation(mouse);
	
	switch ([theEvent keyCode]) {
		case 111:
			[_del willGetClickPoint:point];
			break;
		case 53:
			[_del willCloseChildWindow];
		default:
			break;
	}
	CFRelease(mouse);
}
@end
