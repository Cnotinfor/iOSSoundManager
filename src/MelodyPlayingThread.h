//
//  MelodyPlayingThread.h
//
#import <Foundation/Foundation.h>
#import "Macros.h"
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
