//
//  Source.m
//

#import "Source.h"
#import "SoundManager.h"

@implementation Source

@synthesize name = _name;
@synthesize emitSignal = _emitSignal;


/*
 Inits the source
 Creates a OpenAL Source
 
 Creates a thread for playing the sound if necessary, if requires
 signal its end.
 */
- (id)init
{
	if (self == [super init])
	{
		alGetError();
		alGenSources(1, &_source);
		if( [SoundManagerCore checkOpenALErrors] )
		{
			[self release];
			return nil;
		}
		
		_timeUsed = 0;
		
		_name = nil;
        
        _emitSignal = TRUE;
        
        _lock = [[NSLock alloc] init];
	}
    
	return self;
}

- (void)dealloc
{
	if( [self isPlaying] )
	{
		[self stop];
	}
	
	alDeleteSources(1, &_source);
	[_name release];
    
    [_lock release];
    _lock = nil;
    
	[super dealloc];
}

/*
 Test if the source is playing
 */
- (BOOL)isPlaying
{
	ALint state;
	
	alGetSourcei(_source, AL_SOURCE_STATE, &state );
    @synchronized(self) {	
        return (state == AL_PLAYING) ? YES : NO;
    }
}

- (BOOL)isStopped
{
	ALint state;
	
	alGetSourcei(_source, AL_SOURCE_STATE, &state );
	
	return (state == AL_STOPPED) ? YES : NO;
}


/*
 
 */
- (BOOL)isAvailable
{
	ALint state;
	
	alGetSourcei(_source, AL_SOURCE_STATE, &state );
	//return (state ==AL_STOPPED?true:false);
	return (state != AL_PLAYING && state != AL_PAUSED) ? YES : NO;
}

/*
 Plays a buffer.
 
 It doesn't emit a signal when playing
 */
- (BOOL)playBuffer:(Buffer*)buffer
{
	return [self playBuffer:buffer withName:nil loop:NO];
}

/*
 Plays a buffer and emits a signal when the sound stops
 It uses a thread to check if the sound finished.
 */
- (BOOL)playBuffer:(Buffer*)buffer withName:(NSString*)name
{
	return [self playBuffer:buffer withName:name loop:NO];
}


- (BOOL)playBuffer:(Buffer*)buffer withName:(NSString*)name loop:(BOOL)loop
{	
	_name = [[NSString stringWithFormat:@"%@", name] retain];
	
	_timeUsed = time(NULL); // Update time with current time;
    
	// Stop previous sound
	if( [self isPlaying] )
	{
		[self stop];
	}
	
	alGetError();
	alSourcei(_source, AL_BUFFER, [buffer bufferId]);
	alSourcef(_source, AL_GAIN, [buffer volume]);
	alSourcei(_source, AL_LOOPING, loop ? AL_TRUE : AL_FALSE);
	alSourcef(_source, AL_PITCH, 1.0);
    
	if( [SoundManagerCore checkOpenALErrors] )
	{
		return NO;
	}
	
	alSourcePlay( _source );
	
	if( [SoundManagerCore checkOpenALErrors] )
	{
		return NO;
	}
	
	if( name != nil )
	{
        @synchronized(self){
            [NSThread detachNewThreadSelector:@selector(checkSourceStateThread:) toTarget:self withObject:name];
        }
	}
	
	return YES;
}



/*
 Method to be executed in another thread to check if the sound is still playing
 When the sound finished, it sends a SIGNAL_SOUND_FINISHED
 */
- (void)checkSourceStateThread:(NSString*)name
{	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	ALint state;
	do
	{
        @synchronized(self) {
		// Update source state;
        alGetError();
		alGetSourcei( _source, AL_SOURCE_STATE, &state );
        alGetError();
        }
	}
	while( state == AL_PLAYING);
    //	while( state != AL_STOPPED  && ![self isCancelled] );
	
	// Check if the signal should be emmited
    if (_emitSignal) {
        
        NSDictionary* dict = nil;
        
        // Test if the sound name is defined. If it, use it to send the sound name in the dictionary
        if( name != nil )
        {
            dict = [NSDictionary dictionaryWithObjectsAndKeys:name, KEY_SOUND_NAME, nil];
            if (dict!=nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_SOUND_FINISHED object:nil userInfo:dict];    
            }
            
        }
    }
    
    [pool drain];
}


- (void)stop
{	
	alSourceStop(_source);
    [_lock lock];
    [_lock unlock];
}

- (time_t)timeLastUsed
{
	return _timeUsed;
}


@end
