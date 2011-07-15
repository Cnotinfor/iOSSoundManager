//
//  SoundPlayingThread.h
//

#import <Foundation/Foundation.h>
#import "Macros.h"

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
