//
//  IGKFilterBarTableView.m
//  Ingredients
//
//  Created by Alex Gordon on 17/04/2010.
//  Copyright 2010 Fileability. All rights reserved.
//

#import "IGKFilterBarTableView.h"


@implementation IGKFilterBarTableView

- (NSRect)frameOfCellAtColumn:(NSInteger)column row:(NSInteger)row
{
	if ([[self dataSource] filterBarTableRowIsGroup:row])
	{
		NSRect r = NSInsetRect([self rectOfRow:row], 6, 3);
		r.origin.y += 2.0;
		return r;
	}
	
	return [super frameOfCellAtColumn:column row:row];
}

@end
