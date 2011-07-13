//
//  MelodyPlayingThread.h
//  SoundManagerIOS
//
//  Created by Tiago Correia on 11/03/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Melody.h"


@interface MelodyPlayingThread : NSThread {
	Melody*  _melody;
	ALuint*   _sources;
	ALuint*   _buffers;
	
	ALuint* _state;
}

- (id)init;

- (id)initWithSource:(ALuint*)sources;

- (void)start:(Melody*)melody;

- (void)main;

- (ALboolean) updateSourceState;

@end
