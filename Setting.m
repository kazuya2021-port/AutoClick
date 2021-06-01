//
//  Setting.m
//  AutoClick
//
//  Created by 内山　和也 on 平成28/04/18.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import "Setting.h"
#import <Carbon/Carbon.h>
#import "ZahyouData.h"


@implementation Setting

//----------------------------------------------------------------------------//
#pragma mark -
#pragma mark Initialization
//----------------------------------------------------------------------------//
- (id)init
{
	self = [super init];
	if (!self) 
	{
		return nil;
	}

	zahyouData = [NSMutableArray array];
	[zahyouData retain];
	window = nil;
	clickTotalDelay = 0;
	clickPerDelay = 0;
	return self;
}

- (void)awakeFromNib
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData* dat = [defaults dataForKey:@"zahyou"];
	NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
	double tdl = [defaults doubleForKey:@"totalDelay"];
	double pdl = [defaults doubleForKey:@"perDelay"];
	if (array) {
		zahyouData = [array mutableCopy];
		[zahyouData retain];
		[tZahyou noteNumberOfRowsChanged];
		[tZahyou reloadData];
	}
	if (tdl != 0){
		clickTotalDelay = tdl;
		[t setDoubleValue:(clickTotalDelay * 1000)];
	}
	if (pdl != 0){
		clickPerDelay = pdl;
	}	
}


-(IBAction)clickGetZahyou:(id)sender
{
	
	NSRect rect = [[NSScreen mainScreen] frame];
	
	if(window == nil)
	{
		window = [[OverlayWindow alloc] initWithContentRect:rect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		[window setDelegate:self];
		[main addChildWindow:window ordered:NSWindowAbove];
	}
	else {
		[window makeKeyAndOrderFront:self];
		[NSApp activateIgnoringOtherApps:YES];
	}

}

-(void)FireClick
{
	NSDate *startDate;
	NSDate *endDate;

	for(ZahyouData* dic in zahyouData)
	{
		// 処理開始位置で現在時間を代入
		startDate = [NSDate date];
		NSPoint p = NSPointFromString(dic._point);
		int count = [dic._ccount intValue];
		[self moveCursor:p];
		for(int i = 0; i < count; i++)
		{
			[self performClick:p];
			[self doubleClick:p];
		}
		// 処理終了位置で現在時間を代入
		endDate = [NSDate date];
		NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
		if(interval < clickPerDelay)
		{
			NSTimeInterval newDelay = clickPerDelay - interval;
			NSLog(@"%.3f秒",newDelay);
			[NSThread sleepForTimeInterval:newDelay];
		}
	}
	
}

-(IBAction)clickGo:(id)sender
{
	double delayInSeconds = 3.0;
	clickTotalDelay = [t doubleValue] / 1000;
	int totalClickCount = 0;
	for(ZahyouData* dic in zahyouData)
	{
		int count = [dic._ccount intValue];
		for(int i = 0; i < count; i++)
		{
			totalClickCount++;
		}
	}
	clickPerDelay = clickTotalDelay / totalClickCount;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[self FireClick];
	});
}

-(IBAction)cllearTable:(id)sender
{
	zahyouData = [NSMutableArray array];
	[zahyouData retain];
	[tZahyou noteNumberOfRowsChanged];
	[tZahyou reloadData];
}

-(IBAction)apperSetting:(id)sender
{
	[pnl makeKeyAndOrderFront:self];
	[NSApp activateIgnoringOtherApps:YES];
}

-(IBAction)saveSetting:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	clickTotalDelay = [t doubleValue] / 1000;
	NSData* dat = [NSKeyedArchiver archivedDataWithRootObject:zahyouData];
	[defaults setObject:dat forKey:@"zahyou"];
	[defaults setDouble:clickTotalDelay forKey:@"totalDelay"];
	[defaults setDouble:clickPerDelay forKey:@"perDelay"];
	BOOL successful = [defaults synchronize];
	if (successful) {
		NSLog(@"%@", @"データの保存に成功しました。");
	}
}
- (void)controlTextDidEndEditing:(NSNotification *)obj
{
	clickTotalDelay = [t doubleValue] / 1000;
}


//--------------------------------------------------------------//
#pragma mark -
#pragma mark Functions For Controll Mouse
//--------------------------------------------------------------//
// カーソルを移動する
- (void)moveCursor:(CGPoint)moveto
{
	CGDirectDisplayID dispID = CGMainDisplayID();
	CGDisplayMoveCursorToPoint(dispID, moveto);
}

// クリックする
- (void)performClick:(CGPoint)clickPoint
{
	CGEventRef theEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, clickPoint, kCGMouseButtonLeft); 
    CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, 1);  
    CGEventPost(kCGHIDEventTap, theEvent);  
    CGEventSetType(theEvent, kCGEventLeftMouseUp);  
    CGEventPost(kCGHIDEventTap, theEvent);  
    CFRelease(theEvent); 
}

-(void)doubleClick:(CGPoint)clickPoint
{
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, clickPoint, kCGMouseButtonLeft);  
    CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, 2);  
    CGEventPost(kCGHIDEventTap, theEvent);  
    CGEventSetType(theEvent, kCGEventLeftMouseUp);  
    CGEventPost(kCGHIDEventTap, theEvent);  
    CGEventSetType(theEvent, kCGEventLeftMouseDown);  
    CGEventPost(kCGHIDEventTap, theEvent);  
    CGEventSetType(theEvent, kCGEventLeftMouseUp); 
    CGEventPost(kCGHIDEventTap, theEvent); 
    CFRelease(theEvent); 
}

//----------------------------------------------------------------------------//
#pragma mark -
#pragma mark NSTableView
//----------------------------------------------------------------------------//
- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	if (aTableView == tZahyou)
	{
		return [zahyouData count];
	}
	
	return 0;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(int)rowIndex
{
	if (aTableView == tZahyou) 
	{
		// 番号の列
		if([[aTableColumn identifier] isEqualToString:@"No"]) 
		{
			return [NSNumber numberWithInt:rowIndex + 1];
		}
		// 回数の列
		else if([[aTableColumn identifier] isEqualToString:@"Count"]) 
		{
			ZahyouData* z = [zahyouData objectAtIndex:rowIndex];
			return z._ccount;
		}
		// 座標の列
		else if([[aTableColumn identifier] isEqualToString:@"zahyou"]) 
		{
			ZahyouData* z = [zahyouData objectAtIndex:rowIndex];
			NSPoint p = NSPointFromString(z._point);
			return [NSString stringWithFormat:@"x=%.0f ,y=%.0f", p.x, p.y];
		}
	}
	
	// ここには来ないはず
	return nil;
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex 
{
    if (aTableView == tZahyou) 
	{
		ZahyouData* rowData = [zahyouData objectAtIndex:rowIndex];
		ZahyouData* setData = [[[ZahyouData alloc] init] autorelease];
		
		if ([[aTableColumn identifier] isEqualToString:@"Count"])
		{
			setData._ccount = anObject;
			setData._point = rowData._point;
			[zahyouData replaceObjectAtIndex:rowIndex withObject:setData];
		}
	}
}

- (void)willGetClickPoint:(CGPoint)point
{
	ZahyouData* dic = [[[ZahyouData alloc] init] autorelease];
	dic._ccount = [NSNumber numberWithInt:1];
	dic._point = NSStringFromPoint(NSMakePoint(point.x, point.y));
	NSLog(@"x=[%f] y=[%f]", point.x, point.y);
	[zahyouData addObject:dic];
}

- (void)willCloseChildWindow
{
	[main removeChildWindow:window];
	[window orderOut:self];
	[main makeKeyWindow];
	[NSThread sleepForTimeInterval:0.1];
	[tZahyou noteNumberOfRowsChanged];
	[tZahyou reloadData];
	NSLog(@"reload");	
}
@end
