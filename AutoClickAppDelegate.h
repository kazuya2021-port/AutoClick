//
//  AutoClickAppDelegate.h
//  AutoClick
//
//  Created by 内山　和也 on 平成28/04/18.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AutoClickAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
