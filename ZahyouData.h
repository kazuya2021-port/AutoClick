//
//  ZahyouData.h
//  AutoClick
//
//  Created by 内山　和也 on 平成28/04/18.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ZahyouData : NSObject <NSCoding>{
	NSNumber*	_ccount;
	NSString*	_point;
}
@property(nonatomic, copy) NSNumber* _ccount;
@property(nonatomic, copy) NSString*	_point;
@end
