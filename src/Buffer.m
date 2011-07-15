//
//  Buffer.m
//

#import "Buffer.h"
#import "MyOpenALSupport.h"
#import "SoundManagerCore.h"

@implementation Buffer

#pragma mark -
#pragma mark Initializations


/*
 This method should not be used, so if it is called, it doesn't work.
 It always returns nil
 */
- (id)init
{
	[self release];
	return nil;
}


/*
 Init a Buffer is a file url to a sound file
 It must be a Wave file
 */
- (id)init:(CFURLRef) soundFileURL
{
	if(self == [super init])
	{
		int frequency;
		ALenum format;
		
		// Clear any previous error log
		alGetError();
		
		// Generate the OpenAL bufferID
		alGenBuffers( 1, &_id );
		
		// TODO
		// Check in Apple documentation if this is correct
		if( [SoundManagerCore checkOpenALErrors] )
		{
			[super release];
			return nil;
		}
		
		// Get the raw sound data from the file
		_data = MyGetOpenALAudioData( soundFileURL, &_size, &format, &frequency );
		
		if(_data == NULL) // invalid data
		{
			[self release];
			return nil;
		}
		
		[SoundManagerCore checkOpenALErrors];
		// Associate the data loaded with the buffer created
		alBufferDataStaticProc( _id, format, _data, _size, frequency );
		if( [SoundManagerCore checkOpenALErrors] )
		{
			free( _data );
			[self release];
			return nil;
		}
		
		// Default volume
		_volume = 1;
	}
	
	return self;
}



- (void) dealloc
{
    //	NSLog(@"dealloc Buffer");
	
	// Release the buffer from memory
	if( _data != NULL )
	{
		free( _data );
	}
	
	alDeleteBuffers( 1, &_id );
	if( [SoundManagerCore checkOpenALErrors] )
	{
	}
	
    //	NSLog(@"Buffer dealloc");
    
	[super dealloc];
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"Buffer (%d) size: %d bytes, volume: %0.2f", _id, _size, _volume];
}

#pragma mark -
#pragma mark Buffer information

/*
 Set the volume for playing this buffer
 */
- (void) setVolume:(float) volume
{
	_volume = volume;
}

/**
 Return the volume that should be used to play this buffer
 */
- (float) volume
{
	return _volume;
}

/**!
 Returns a pointer to the raw sound data
 */
- (ALvoid*) data
{
	return _data;
}

/*
 Returns the size in bytes of the buffer data
 */
- (int) size
{
	return _size;
}

/*!
 Returns the OpenAL buffer Id
 */
- (ALuint) bufferId
{
	return _id;
}


- (ALfloat)durationOfBuffer:(ALuint)aBufferId{
    
    ALint size, bits, channels, freq;
    alGetBufferi(aBufferId, AL_SIZE, &size);
    alGetBufferi(aBufferId, AL_BITS, &bits);
    alGetBufferi(aBufferId, AL_CHANNELS, &channels);
    alGetBufferi(aBufferId, AL_FREQUENCY, &freq);
    
    if(alGetError() != AL_NO_ERROR)        
        return -1.0f;    
    return (ALfloat)((ALuint)size/channels/(bits/8)) / (ALfloat)freq;
}

@end
