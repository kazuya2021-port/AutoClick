//
//  ZahyouData.m
//  AutoClick
//
//  Created by 内山　和也 on 平成28/04/18.
//  Copyright 2016 __MyCompanyName__. All rights reserved.
//

#import "ZahyouData.h"

@implementation ZahyouData

@synthesize _ccount, _point;

-(void)dealloc
{
	self._ccount = nil;
	self._point = nil;
	[super dealloc];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self._ccount forKey:@"COUNT"];
	[aCoder encodeObject:self._point forKey:@"POINT"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if(self){
		self._ccount = [aDecoder decodeObjectForKey:@"COUNT"];
		self._point = [aDecoder decodeObjectForKey:@"POINT"];
	}
	return self;
}
@end
