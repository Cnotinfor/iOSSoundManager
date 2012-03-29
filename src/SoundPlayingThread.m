//
//  SoundPlayingThread.m
//
/*
	This class is thread to check if a sound finished playing
*/

#import "SoundPlayingThread.h"
#import "SoundManager.h"


@implementation SoundPlayingThread

#pragma mark -
#pragma mark Initializations

/**
	It should not be used. Use initWithSource
*/
- (id) init
{
	[self release];
	return nil;
}

/**
	
*/
- (id) initWithSource:(ALuint)source
{
	if( self == [super init] )
	{
//		[self setSource:source];
		_source = source;
		_emitSignal = YES;
		_soundName = nil;
	}
	
	return self;
}



#pragma mark -
#pragma mark Implementation

- (id) start:(NSString*)soundName
{
	_soundName = soundName;
	
	[self start];
	
	return nil;
}

/*
	Main thread loop
*/
- (void) main
{
	// Test if the source is set
	if ( _source == 0)
	{
		return; // no source set
	}
	
	// loop for testing if the sound finished
	do
	{
		
		if( ![self updateSourceState] )
		{
			return; // Cancel thread on error while getting the source state
		}
		
		if( _state == AL_STOPPED )
		{
			break; // stop loop, the sound is stopped
		}
		
		// Small delay on the thread, so it doesn't use so much CPU
//		sleepForTimeInterval:0.01; // 10 miliseconds
	}
	while( ![self isCancelled] );
	
	// Check if the signal should be emmited
	NSDictionary* dict = nil;
		
	// Test if the sound name is defined. If it, use it to send the sound name in the dictionary
	if( _soundName != nil )
	{
		dict = [NSDictionary dictionaryWithObjectsAndKeys:_soundName, KEY_SOUND_NAME, nil];
	}
		
	[[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_SOUND_FINISHED object:nil userInfo:dict];

}


/*
	Update the source state. It returns TRUE if it managed to update the source.
*/
- (ALboolean) updateSourceState
{
	alGetError();
	alGetSourcei( _source, AL_SOURCE_STATE, &_state );
	
	return alGetError() ? AL_FALSE : AL_TRUE;
}

@end
