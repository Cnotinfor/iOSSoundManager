//
//  MelodyPlayingThread.m
//

#import "MelodyPlayingThread.h"


@implementation MelodyPlayingThread


/*
	Don't use this method
*/
- (id)init
{
	[self release];
	return nil;
}

- (id)initWithSource:(ALuint*)sources
{
	if (self == [super init]) {
		_sources = sources;
		_buffers = 0;
	}

	return self;
}

- (void)start:(Melody*)melody
{
	_melody = melody;
	
	// Alloc memory for the buffers
	// The number of buffers is equal to the number of notes of the melody
	_buffers = (ALuint*) malloc([melody numberOfNotes] * sizeof(ALuint));
	
	[self start];
}

- (void)main
{
	// Set the numbers of sources needed
	int n_rhythms = [[_melody rhythms] count];
	ALsizei n_sources = 1 + n_rhythms;
	ALint buffersPlayed = 0;
	ALint tmp;
	
	// Build a buffer array;
	// get buffers id from the SoundCoreManager
	// TODO
	
	alSourceQueueBuffers(_sources[0], [_melody numberOfNotes], _buffers);
	
	// Associate each sources for each rhythm
	for (int i = 1; i <= n_rhythms; i++) {
		// get
		ALuint b;
		
		// associate a source with the buffer of the rhythm
		alSourcei(_sources[i], AL_BUFFER, b);
		alSourcei(_sources[i], AL_LOOPING, AL_TRUE);
	}
	
	// play the sources
	alSourcePlayv( n_sources, _sources );
	// emit melody started TODO
	
	// loop waiting for
	do
	{
		alGetError();
		alGetSourcei(_sources[0], AL_BUFFERS_PROCESSED, &tmp);
		
		// Check if a note changed
		if( tmp > buffersPlayed)
		{
			// emit note finished TODO
			// emit note started TODO
		}
		
		if( (int)_state == AL_STOPPED )
		{
			// emit melody stop TODO
			break; // stop loop, the sound is stopped
		}
		
		// Small delay on the thread, so it doesn't use so much CPU
		//sleepForTimeInterval:SLEEP_INTERVAL; // 10 miliseconds
	}
	while( ![self isCancelled] );	
}

- (ALboolean) updateSourceState
{
	
	return FALSE;
}

@end
