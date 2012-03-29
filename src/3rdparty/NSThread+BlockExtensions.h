//
//  NSThread+BlockExtensions.h
//  Escape
//
//  Created by Bartłomiej Wilczyński on 7/26/10.
//  Copyright 2010 XPerienced. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSThread (BlocksExtensions)

- (void)performBlock:(void (^)())block;
- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait;
+ (void)performBlockInBackground:(void (^)())block;

@end
