//
//  NSThread+BlockExtensions.m
//  Escape
//
//  Created by Bartłomiej Wilczyński on 7/26/10.
//  Copyright 2010 XPerienced. All rights reserved.
//

#import "NSThread+BlockExtensions.h"


@implementation NSThread (BlocksExtensions)

- (void)performBlock:(void (^)())block
{
	if ([[NSThread currentThread] isEqual:self])
		block();
	else
		[self performBlock:block waitUntilDone:NO];
}

- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait
{
    [NSThread performSelector:@selector(performBlock:)
                     onThread:self
                   withObject:[[block copy] autorelease]
                waitUntilDone:wait];
}

+ (void)performBlockInBackground:(void (^)())block
{
	[NSThread performSelectorInBackground:@selector(performBlock:)
	                           withObject:[[block copy] autorelease]];
}

+ (void)performBlock:(void (^)())block
{
	block();
}

@end
