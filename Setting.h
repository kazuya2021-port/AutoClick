//
//  Setting.h
//  AutoClick
//
//  Created by 内山　和也 on 平成28/04/18.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OverlayWindow.h"

@interface Setting : NSObject <OverlayWindowDelegate> {
	NSMutableArray*		zahyouData;
	NSTimeInterval		clickTotalDelay;
	NSTimeInterval		clickPerDelay;
	IBOutlet NSTableView* tZahyou;
	IBOutlet NSWindow* main;
	IBOutlet NSTextField* t;
	OverlayWindow*	window;
	IBOutlet NSPanel*	pnl;
}
- (void)moveCursor:(CGPoint)moveto;
- (void)performClick:(CGPoint)clickPoint;
-(void)doubleClick:(CGPoint)clickPoint;
-(IBAction)apperSetting:(id)sender;
-(IBAction)saveSetting:(id)sender;
-(IBAction)clickGetZahyou:(id)sender;
-(IBAction)clickGo:(id)sender;
-(IBAction)cllearTable:(id)sender;
@end
