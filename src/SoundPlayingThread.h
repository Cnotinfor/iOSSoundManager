//
//  CheckSoundsThread.h
//  SoundManagerIOS
//
//  Created by Tiago Correia on 11/03/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>


// 10 milliseconds

@interface SoundPlayingThread : NSThread {
	ALuint   _source;
	ALint    _state; // source state
	NSString* _soundName;
	
	BOOL _emitSignal;
}

- (id) init;

- (id) initWithSource:(ALuint)source;

- (id) start:(NSString*)soundName;

- (void) main;

- (ALboolean) updateSourceState;


@end
