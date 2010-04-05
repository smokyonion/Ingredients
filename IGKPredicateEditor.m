//
//  IGKPredicateEditor.m
//  Ingredients
//
//  Created by Alex Gordon on 23/03/2010.
//  Copyright 2010 Fileability. All rights reserved.
//

#import "IGKPredicateEditor.h"


@implementation IGKPredicateEditor

- (NSPredicate *)predicate
{
	//We want to remove any null comparison predicates from our predicate
	NSCompoundPredicate *predicate = [super predicate];
	NSLog(@"Pre = %@", predicate);
	
	if (!predicate)
		return nil;
	
	if ([predicate isKindOfClass:[NSComparisonPredicate class]])
	{
		predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:[NSArray arrayWithObject:predicate]];
	}
	else if (![predicate isKindOfClass:[NSCompoundPredicate class]])
	{
		return predicate;
	}
	
	requestedEntityName = @"Any";
	
	NSArray *subpredicates = [predicate subpredicates];
	NSMutableArray *newSubpredicates = [[NSMutableArray alloc] initWithCapacity:[subpredicates count]];
	
	for (NSComparisonPredicate *cmpP in subpredicates)
	{
		NSExpression *right = [cmpP rightExpression];
		NSExpression *left = [cmpP leftExpression];
		
		if([[left keyPath] isEqual:@"xkind"])
		{
			//NSLog(@"Rught: %@", [right constantValue]);
			requestedEntityName = [right constantValue];
			continue;
		}
		

		if ([right expressionType] != NSConstantValueExpressionType)
		{
			[newSubpredicates addObject:cmpP];
			continue;
		}
		
		id cv = [right constantValue];
		
		if (cv && (![cv respondsToSelector:@selector(length)] || [cv length] > 0))
		{
			[newSubpredicates addObject:cmpP];
		}
		

		
	}
	
	NSLog(@"newSubpredicates = %@", newSubpredicates);
	
	return [[NSCompoundPredicate alloc] initWithType:[predicate compoundPredicateType] subpredicates:newSubpredicates];
}


- (NSPredicate *)predicateWithEntityNamed:(NSString **)outEntityName
{
	NSPredicate *newPredicate = [self predicate];
	
	if (outEntityName != NULL)
	{
		if([requestedEntityName isEqual:@"Class"])
		{
			requestedEntityName = @"ObjCClass";
		}
		else if([requestedEntityName isEqual:@"Protocol"])
		{
			requestedEntityName = @"ObjCProtocol";
		}
		else {
			requestedEntityName = @"DocRecord";
		}

		
		*outEntityName = requestedEntityName;
	}
	return ;
}

@end
