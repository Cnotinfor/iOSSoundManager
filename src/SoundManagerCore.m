#import "SoundManagerCore.h"
#import "CnotiAudio.h"
#import "Buffer.h"

#import "Source.h"

@implementation SoundManagerCore


@synthesize buffersNotes = _buffersNotes;
@synthesize buffersRhythms = _buffersRhythms;
@synthesize loadingPath = _loadingPath;
@synthesize notesPath = _notesPath;
@synthesize rhythmsPath = _rhytmsPath;
@synthesize buffersInstruments = _buffersInstrument;

@synthesize volume = _volume;

@synthesize signalsEnabled;


- (id)init
{
	if(self == [self initWithSettings:nil])
	{
	}
	
	return self;
}


- (id)initWithSettings:(NSUserDefaults*) defaults
{
	if(self == [super init])
	{
		if(![self initOpenAL])
		{
			
		}
		
		if(![self initSources])
		{
			
		}
		
		if(![self initBuffers])
		{
			
		}
		
		[self initVolumeFromSettings:defaults];
		
		_melodySourcesPlaying = 0;
	}
	
	return self;
}


- (BOOL) initOpenAL
{
//	NSLog(@"[SoundManagerCore::initOpenAL]");
	
	// Get the default sound device
	_device = alcOpenDevice(NULL);
	
	if( _device )
	{
		// Create a context for playing the sounds
		_context = alcCreateContext(_device, NULL);
		[SoundManagerCore checkOpenALErrors];
		
		// Make the context we have just created into the active context
		alcMakeContextCurrent(_context);
		[SoundManagerCore checkOpenALErrors];
		
		// Set the distance model to be used
		alDistanceModel(AL_NONE);
		
//		NSLog(@"[SoundManagerCore::initOpenAL] Finished with sucess");
		// Return YES as we have successfully initialized OpenAL
		return YES;
	}
	
	// We were unable to obtain a device for playing sound so tell the user and return NO.
//	NSLog(@"[SoundManagerCore::initOpenAL] Error");
	return NO;
}


/*
 Create the source objects that will be responsible for playing 
 the sounds.
 */
- (BOOL) initSources
{
	NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:MAX_AL_SOURCES];
	
	for(int i=0; i < MAX_AL_SOURCES; i++ )
	{
		Source* s = [[Source alloc] init];
		[tmpArray addObject:s];
		[s release];
	}
	
	_soundSources = [tmpArray copy];
	
	
	// Init melody Sources
	alGenSources(NUM_MELODY_SOURCES, _melodySources );
	
	
	return [SoundManagerCore checkOpenALErrors];
}


/*
 Init the buffers to add OpenAL sounds buffers
 */
- (BOOL) initBuffers
{
	_buffers = [[NSMutableDictionary alloc] init];
	_buffersNotes = [[NSMutableDictionary alloc] init];
	_buffersRhythms = [[NSMutableDictionary alloc] init];
	
	return TRUE;
}


/*
 Get the initial value from value from the settings
 
 If defaults is nill, it uses
 */
- (BOOL) initVolumeFromSettings:(NSUserDefaults*) defaults
{
	if (defaults != nil)
	{
		id obj = [defaults objectForKey:@"Volume"];
		
		if(obj == nil)
		{
			_volume = [defaults floatForKey:@"Default Value"];
		}
		else
		{
			_volume = (float) [(NSDecimalNumber*) obj doubleValue];
		}
	}
	else
	{
		// No settings, it uses the default
		_volume = 1;
		_instrumentsVolume[Instrument_FLUTE] = 0.1;
		_instrumentsVolume[Instrument_PIANO] = 0.7;
		_instrumentsVolume[Instrument_TRUMPET] = 0.15;
		_instrumentsVolume[Instrument_XYLOPHONE] = 0.6;
		_instrumentsVolume[Instrument_VIOLIN] = 0.15;
		
		_rhythmsVolume[Rhythm_CHINESE_BOX] = 0.9;
		_rhythmsVolume[Rhythm_BASS_DRUM] = 1;
		_rhythmsVolume[Rhythm_CONGAS] = 0.5;
		_rhythmsVolume[Rhythm_TAMBOURINE] = 0.3;
		_rhythmsVolume[Rhythm_TRIANGLE] = 0.9;
		_rhythmsVolume[Rhythm_BEAT_BOX] = 0.15;
	}
	
	return TRUE;
}


- (void) releaseOpenAL
{
	// Remove and delete context
	alcMakeContextCurrent( NULL );
	[SoundManagerCore checkOpenALErrors];
	alcDestroyContext( _context );
	[SoundManagerCore checkOpenALErrors];
	
	// Close the device
	alcCloseDevice( _device );
	[SoundManagerCore checkOpenALErrors];
	
//	NSLog( @"[SoundManager::releaseOpenAL] OpenAL resources released" );
}


- (void) dealloc
{
	// Release the sound sources
	[_soundSources release];
	
	// release the buffers
	[_buffers release];
	[_buffersNotes release];
	[_buffersRhythms release];
	
	// release OpenAL, should be after removing the buffers and the sources
	[self releaseOpenAL];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Paths methods

- (void) setSoundsPath:(NSString*) path
{
	_soundsPath = path;
}


- (void) setInstrumentsPath:(NSString*) path
{
	_instrumentsPath = path;
//	NSLog(@"---->%@", _instrumentsPath);
}


- (void) setRhythmsPath:(NSString*) path
{
	_rhythmsPath = path;
}

#pragma mark -
#pragma mark Loading methods

- (void)setLoadIfNecessary:(BOOL)load
{
	_loadSounds = load;
}


/*
 Loads a wave files from the resources to the buffers lists
 
 The wave file name, doesn't require the extension
 */
- (Buffer*) loadWave:(NSString*)resource path:(NSString*)path
{
	NSBundle* bundle = [NSBundle mainBundle];
	
	// Test if the path is valid
	NSString* directory = [NSString stringWithString:@""];
	if (path != nil)
	{
		directory = path;	
	}
	
	NSString* r = [bundle pathForResource:resource ofType:@"wav" inDirectory:directory];
	if( r == nil )
	{
		return NULL;
	}
	
	CFURLRef soundURL = (CFURLRef)[NSURL fileURLWithPath:r];
	
	
	// Test if the resource exists
	if (!soundURL)
	{
		return NULL;
	}
	
	
	Buffer* buffer = [[Buffer alloc] init: soundURL];
//	[soundURL release];
	if(!buffer)
	{
//		NSLog(@"[SoundManagerCore::loadWave] Error creating the buffer, resource = %@", path);
//		NSLog(@"[SoundManagerCore::loadWave] Error creating the buffer, resource = %@", resource);
		return NULL;
	}
    
	return [buffer autorelease];
}


/*
 Loads a wave files from the resources to the buffers lists
 
 The wave file name, doesn't require the extension
 */
- (BOOL) loadSound:(NSString*) resource
{	
	return [self loadSound:resource name:resource];
}


/*
 Loads a wave files from the resources to the buffers lists
 
 The wave file name, doesn't require the extension
 */
- (BOOL) loadSound:(NSString*)resource name:(NSString*)name
{
	// Test if a sound with the name is already loaded;
	if( [self isSoundLoaded:name] )
	{
		// if it, it doesnt load the file
		return YES;
	}
	
	Buffer* buffer = [self loadWave:resource path:_soundsPath];
	
	if(!buffer)
	{
//		NSLog(@"[SoundManager::loadSound] Error creating the buffer, resource = %@", resource);
		return NO;
	}
	
	// Add buffer to the buffers list
	[_buffers setValue:buffer forKey:name];
	
	return YES;
}



/*
 Load all notes from a instrument with a tempo to memory
 */
- (BOOL) loadInstrument:(int)instrument tempo:(int)tempo
{
	[self loadPauses:tempo];
	
	int heights[8] = {0,2,4,5,7,9,11,0};
	int octaves[8] = {3,3,3,3,3,3,3,4};
	int durations[4] = {32,64,96,128};
	
	for(int i = 0; i < 8; i++)
	{
		for(int d = 0; d < 4; d++)
		{
			if(![self loadNote:instrument tempo:tempo height:heights[i] duration:durations[d] octave:octaves[i]])
			{
				return NO;
			}
		}
	}
	
	return YES;
}



- (BOOL) loadPauses:(int)tempo
{
	int durations[4] = {32,64,96,128};
	
	for(int d = 0; d < 4; d++)
	{
		if(![self loadPause:tempo duration:durations[d]])
		{
			return NO;
		}
	}	
	return YES;
}


- (BOOL)loadPause:(int)tempo duration:(int)duration
{
	
//	NSLog(@"loadPause");
	NSString* resource = [SoundManagerCore pauseName:tempo duration:duration];
	
	// Test if a sound with the name is already loaded;
	if( [self isNoteLoaded:resource] )
	{
		// if it, it doesnt load the file
		return YES;
	}
	
	Buffer* buffer = [self loadWave:resource path:_instrumentsPath];
	
	if(!buffer)
	{
//		NSLog(@"[SoundManager::loadPause] Error creating the buffer, resource = %@", resource);
		return NO;
	}
	
	// Add buffer to the buffers list
	[_buffersNotes setValue:buffer forKey:resource];
	
	return YES;
}

- (BOOL)loadNote:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int)octave
{
	NSString* resource = [SoundManagerCore noteName:instrument tempo:tempo height:height duration:duration octave:octave];
	
	// Test if a sound with the name is already loaded;
	if( [self isNoteLoaded:resource] )
	{
		// if it, it doesnt load the file
		return YES;
	}
	
	Buffer* buffer = [self loadWave:resource path:_instrumentsPath];
	
	if(!buffer)
	{
//		NSLog(@"[SoundManager::loadNote] Error creating the buffer, resource = %@", resource);
		return NO;
	}
	
	// Add buffer to the buffers list
	[_buffersNotes setValue:buffer forKey:resource];
	
	return YES;
}


- (BOOL)loadNoteWithFilename:(NSString*)filename
{
	NSString* resource = filename;
	
	// Test if a sound with the name is already loaded;
	if( [self isNoteLoaded:resource] )
	{
		// if it, it doesnt load the file
		return YES;
	}
	
	Buffer* buffer = [self loadWave:resource path:_instrumentsPath];
	
	if(!buffer)
	{
//		NSLog(@"[SoundManager::loadNoteWithFilename] Error creating the buffer, resource = %@", resource);
		return NO;
	}
	
	// Add buffer to the buffers list
	[_buffersNotes setValue:buffer forKey:resource];
	
	
	return YES;
}


/*
 Load all the rhythms variation from a rhythm
 */
- (BOOL)loadRhythm:(int)rhythm tempo:(int)tempo
{
	int variations[5] = {0,1,2,3,4};
	
	for(int i = 0; i < 8; i++)
	{
		for(int d = 0; d < 4; d++)
		{
			if(![self loadRhythm:rhythm tempo:tempo variation:variations[i]])
			{
				return NO;
			}
		}
	}
	return YES;
}


/*
 Load a single Rhythm variation
 */
- (BOOL)loadRhythm:(int)rhythm tempo:(int)tempo variation:(int)variation
{

//	NSLog(@"loadRhtyhm rhythm: %d tempo: %d variation: %d", rhythm, tempo, variation);
	NSString* resource = [SoundManagerCore rhythmName:rhythm tempo:tempo variation:variation];
	
	// Test if a rhythm with the same name is already loaded;
	if( [self isRhythmLoaded:resource] )
	{
		// if it, it doesnt load the file
		return YES;
	}
	
	Buffer* buffer = [self loadWave:resource path:_rhythmsPath];
	
	if(!buffer)
	{
//		NSLog(@"[SoundManager::loadRhythm] Error creating the buffer, resource = %@", resource);
		return NO;
	}
	
	// Add buffer to the buffers list
	[_buffersRhythms setValue:buffer forKey:resource];
	
	return YES;
}


#pragma mark -
#pragma mark Release methods

- (void) releaseSound:(NSString*) name
{
//	[[_buffers objectForKey:name] release];
	[_buffers removeObjectForKey:name];
}


/*
 Removes all buffers in the sounds
 */
- (void) releaseAllSounds
{
	
//	for (id key in _buffers) {
//		id object = [_buffers objectForKey:key];
//	}
	
	[_buffers removeAllObjects];
}


- (void) releaseInstrument:(int) instrument
{
	NSString* prefix = [NSString stringWithFormat:@"%d", instrument];
	
//	[self releaseObjectsWithPrefix:prefix dictionary:_buffersNotes];
	[self removeObjectsWithPrefix:prefix dictionary:_buffersNotes];
	
//	[prefix release];
	
}


- (void) releasePauses:(int)tempo
{
	NSString* prefix = [NSString stringWithFormat:@"pause_%d", tempo];
	
	[self releaseObjectsWithPrefix:prefix dictionary:_buffersNotes];
	[self removeObjectsWithPrefix:prefix dictionary:_buffersNotes];
	
//	[prefix release];
}

- (void) releaseInstrument:(int) instrument tempo:(int) tempo
{
	NSString* prefix = [NSString stringWithFormat:@"%d_%d", instrument, tempo];
	
	[self releaseObjectsWithPrefix:prefix dictionary:_buffersNotes];
	[self removeObjectsWithPrefix:prefix dictionary:_buffersNotes];
	
//	[prefix release];
}


- (void) releaseInstruments
{
	
//	for (id key in _buffersNotes) {
//		id object = [_buffersNotes objectForKey:key];
//		[object release];
//	}
	
	[_buffersNotes removeAllObjects];
}


- (void) releaseRhythm:(int) rhythm tempo:(int) tempo
{
	NSString* prefix = [[NSString alloc] initWithFormat:@"%d_%d", rhythm, tempo];
	
	[self releaseObjectsWithPrefix:prefix dictionary:_buffersRhythms];
	[self removeObjectsWithPrefix:prefix dictionary:_buffersRhythms];
}


- (void) releaseRhythm:(int) rhythm
{
	NSString* prefix = [[NSString alloc] initWithFormat:@"%d", rhythm];
	
	[self releaseObjectsWithPrefix:prefix dictionary:_buffersRhythms];
	[self removeObjectsWithPrefix:prefix dictionary:_buffersRhythms];
}


- (void) releaseRhythms
{
	
//	for (id key in _buffersRhythms) {
//		id object = [_buffersRhythms objectForKey:key];
//		[object release];
//	}
	
	[[self buffersRhythms] removeAllObjects];
}

#pragma mark -
#pragma mark Sound Playing methods

- (void)playSound:(NSString*)name loop:(BOOL)loop
{	
	Source* source = [self nextAvailableSource];
    
    NSLog(@"SoundManagerCore: playSound: %d", signalsEnabled);
    NSLog(@"SoundManagerCore: playSound: source: %@", source);
    
    if (signalsEnabled == FALSE) {
        source.emitSignal = FALSE;
    }
    else {
        source.emitSignal = TRUE;
    }
    
    NSLog(@"SoundManagerCore: playSound: %@", name);
	NSLog(@"SoundManagerCore: playSound: playBuffer %d:", [source playBuffer:[_buffers valueForKey:name] withName:name loop:loop]);
	
	if (signalsEnabled) {
		[[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_SOUND_STARTED object:nil];	
	}
	
//	[NSThread detachNewThreadSelector:@selector(isSoundPlayingThread) toTarget:self withObject:nil];
	
}


- (BOOL)isSoundPlayingThread {
	
	while ([self isSoundPlaying]) {
	}
	
	if (signalsEnabled) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_SOUND_FINISHED object:nil];	
	}
	
	return FALSE;
}


- (void)stopSound:(NSString*)name{
	
	for (int i = 0; i<MAX_AL_SOURCES; i++) {
		Source* source = [_soundSources objectAtIndex:i];
		
		if ([source.name isEqualToString:name]) {
            NSLog(@"SoundManagerCore: stopSound: source.name %@:", source.name);

			[source stop];
		}
	}
}


- (void)stopSounds{
	for (int i = 0; i<MAX_AL_SOURCES; i++) {
		Source* source = [_soundSources objectAtIndex:i];
		[source stop];
	}
}


- (ALfloat)getSoundDuration:(NSString*)aName
{
    // get the buffer by name
    Buffer* buffer = [_buffers valueForKey:aName];
    
    return [buffer durationOfBuffer:[buffer bufferId]];
    
}


- (BOOL)isSoundPlaying{
	
	for (int i = 0; i<MAX_AL_SOURCES; i++) {
		Source* source = [_soundSources objectAtIndex:i];
		
		if ([source isPlaying]) {
			return TRUE;
		}
	}
	
	return FALSE;
}


- (BOOL)isSoundPlaying:(NSString*)name{
	
	for (int i = 0; i<MAX_AL_SOURCES; i++) {
		Source* source = [_soundSources objectAtIndex:i];
		
		if ([source.name isEqualToString:name]) {
			return [source isPlaying];
		}
	}
	
	return FALSE;
}


- (BOOL)isSoundStopped:(NSString*)name{
	
	for (int i = 0; i<MAX_AL_SOURCES; i++) {
		Source* source = [_soundSources objectAtIndex:i];
		
		if ([source.name isEqualToString:name]) {
			return [source isStopped];
		}
	}
	
	return FALSE;
}


#pragma mark -
#pragma mark Melody, Rhythms and Notes methods


- (void)loadMelody:(Melody*)melody
{
	for (int i=0; i<[melody numberOfNotes]; i++) {
		Note* currentNote = [melody.notesList objectAtIndex: i];
		
		if (currentNote.note == -1) {
//			NSLog(@"load Pause");
			[self loadPause:[melody tempo] duration:[currentNote duration]];
		}
		else {			
//			NSLog(@"load Note");
			[self loadNote:[melody instrument] tempo:[melody tempo] height:[currentNote note] duration:[currentNote duration] octave:[currentNote octave]];	
		}
	}
	
	//load rhythms sounds
	
	int variation = 0;
	
	for (int i=0; i<NUM_AVAILABLE_RHYTHMS; i++) {
		variation = [[melody.rhythms objectAtIndex:i] intValue];
		
		if (variation != -1) {
			[self loadRhythm:i tempo:[melody tempo] variation:variation];
		}
	}
}


- (BOOL)playMelody:(Melody*)melody 
{
	
	return [self playMelody:melody loop:FALSE];
}


- (BOOL)playMelody:(Melody*)melody loop:(BOOL)loop
{
	// If the melody is playing, return FALSE
	if( [self isMelodyPlaying] )
	{
		return FALSE;
	}
	
	
	if (_numberOfNotes != 0) {
		
		ALuint* foo = malloc( _numberOfNotes * sizeof(ALuint) );
		alSourceUnqueueBuffers( _melodySources[0], _numberOfNotes, foo);
		if( [SoundManagerCore checkOpenALErrors] )
		{
//			NSLog(@"alSourceUnqueueBuffers Error - 1");
		}	
	}
	
	
	_numberOfNotes = [melody numberOfNotes];
	
	// First source has the instrument melody
	// buffers must be queue in source
	
	// Init buffers array
	_melodyBuffers = malloc( _numberOfNotes * sizeof(ALuint) );
	
	// Fill in the melody buffers, with the notes buffers id
	
	for (int i = 0; i < _numberOfNotes; i++)
	{
		Note* currentNote = [melody.notesList objectAtIndex: i];
		
		Buffer* buffer;
		if (currentNote.note==Note_PAUSE) {
//			NSLog(@"buffer -1");
			buffer = [self pauseBuffer:[melody tempo] duration:[currentNote duration]];	
		}
		else {
//			NSLog(@"buffer +1");
			buffer = [self noteBuffer:[melody instrument] tempo:[melody tempo] height:[currentNote note] duration:[currentNote duration] octave:[currentNote octave]];	
		}
		
		_melodyBuffers[i] = [buffer bufferId];
	}
	
	
	// Queue the buffers in the source 0 = melody source
	alSourceQueueBuffers( _melodySources[0], _numberOfNotes ,_melodyBuffers );
	if ([SoundManagerCore checkOpenALErrors]) {
//		NSLog(@"alSourceQueueBuffers Error - 2");
	}
	
	// For each rhythm, a buffer must be associated to the source
	_melodySourcesPlaying = 1; // to count the number of rhythms associated with a source
	for (int j = 0; j < NUM_AVAILABLE_RHYTHMS; j++)
	{
		int variation = [[[melody rhythms] objectAtIndex:j] intValue];
		if( variation >= 0 )
		{
			// Get rhythm buffer
			Buffer* buffer = [self rhythmBuffer:j tempo:[melody tempo] variation:variation];
			
			_melodyBuffers[_melodySourcesPlaying] = [buffer bufferId];
			
			// associate the buffer with the source
			alSourcei(_melodySources[_melodySourcesPlaying], AL_BUFFER, [buffer bufferId]);
			if ([SoundManagerCore checkOpenALErrors]) {
//				NSLog(@"alSourcei Error - 3");
			}
			
			_melodySourcesPlaying++; // increase source count usage
		}
		
		// Check if the number of sources available ended
		if( _melodySourcesPlaying >= NUM_MELODY_SOURCES )
		{
			break;
		}
		
	}
	
	// set loop mode for the melody source
	alSourcei(_melodySources[0], AL_LOOPING, (loop ? AL_TRUE : AL_FALSE) );
	if ([SoundManagerCore checkOpenALErrors]) {
//		NSLog(@"alSourcei Error - 4");
	}
	
	// rhythms are always in loop mode
	for (int i = 1; i < _melodySourcesPlaying ; i++)
	{
		alSourcei(_melodySources[i], AL_LOOPING, AL_TRUE );
		if ([SoundManagerCore checkOpenALErrors]) {
//			NSLog(@"alSourcei Error - 5");
		}
	}
	
	
	// start playing all the sources
	alSourcePlayv( _melodySourcesPlaying, _melodySources );
	
	if( [SoundManagerCore checkOpenALErrors] )
	{
//		NSLog(@"alSourcei Error - 6");
		return FALSE;
	}
	
	// Start thread to check if the melody is still playing
	// It also emits signal at the end of each note
	
	if (signalsEnabled) {
		[[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_MELODY_STARTED object:nil];	
		[NSThread detachNewThreadSelector:@selector(isMelodyPlayingThread) toTarget:self withObject:nil];

	}	

	return TRUE;
}


- (void)stopMelody
{
	
//	NSLog(@"stopMelody - 1");
	alSourceStopv(_melodySourcesPlaying, _melodySources);

	if( [SoundManagerCore checkOpenALErrors] )
	{
//		NSLog(@"[SoundManagerCore::stopMelody error] melodysourcesplaying: %d", _melodySourcesPlaying);

	}	
	// emit signal finish melody
	if (signalsEnabled) {
		[[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_MELODY_FINISHED object:nil];
	}
	
	// free melody buffers;
	// free( _melodyBuffers );
	// [self stopRhythms];
	
	// Beware simultaneos access stop and play
	
//	NSLog(@"stopMelody - 2");
}

-(void) unqueueBuffers {
	ALuint* foo = malloc( _numberOfNotes * sizeof(ALuint) );
	alSourceUnqueueBuffers( _melodySources[0], _numberOfNotes, foo);
	if( [SoundManagerCore checkOpenALErrors] )
	{
	}
}


- (BOOL)isMelodyPlaying{
	
	ALint state;
	alGetSourcei( _melodySources[0], AL_SOURCE_STATE, &state );
	
	if ([SoundManagerCore checkOpenALErrors])
	{
//		NSLog(@"isMelodyPlaying Error");
		return FALSE;
	}
	
	return( state == AL_PLAYING ? TRUE : FALSE);
}


- (BOOL)isMelodyPlayingThread {
	
//	NSLog(@"[SoundManagerCore::isMelodyPlayingThread - 1]");
	
	int buffersProcessed = 0;
	ALint value; // To get the value of the number of buffers processed by the source
	
	//emit signal first note;
	if (signalsEnabled) {
		[[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_NOTE_STARTED object:nil];
	}
	
	do
	{
//		NSLog(@"[SoundManagerCore::isMelodyPlayingThread - 2]");
		alGetSourcei(_melodySources[0], AL_BUFFERS_PROCESSED, &value);
		
		if ([SoundManagerCore checkOpenALErrors])
		{
//			break;
		}
		
		if(value > buffersProcessed)
		{
			buffersProcessed = value ;
			//emit signal;
			if (signalsEnabled) {
				[[NSNotificationCenter defaultCenter] postNotificationName:SIGNAL_NOTE_STARTED object:nil];
			}			
		}
		
	sleepForTimeInterval:0.0001;
	}
	while ([self isMelodyPlaying]);
	
//	NSLog(@"[SoundManagerCore::isMelodyPlayingThread - 3]");
	
	// emit signal finish melody
	[self stopMelody];
	
//	[self stopMelody];
	return FALSE;
}



- (int)noteBeingPlayed{
	
	return 0;
}


- (void)playNote:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int) octave loop:(BOOL)loop{
	
	NSString* completeNoteFilename = [NSString stringWithFormat:@"%d_%d_%d_%d_%d", instrument, tempo, duration, octave, height]; 
	
	Source* source = [self nextAvailableSource];
	[source playBuffer:[_buffersNotes valueForKey:completeNoteFilename] withName:completeNoteFilename loop:FALSE];
}


- (void)playNoteWithFilename:(NSString*)filename loop:(BOOL)loop{
	
	Source* source = [self nextAvailableSource];
	[source playBuffer:[_buffersNotes valueForKey:filename] withName:filename loop:loop];
}



- (Buffer*)noteBuffer:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int) octave
{
	NSString* name = [SoundManagerCore noteName:instrument tempo:tempo height:height duration:duration octave:octave];
	Buffer* buffer = [_buffersNotes objectForKey:name];
	
	return buffer;
	
}


- (Buffer*)pauseBuffer:(int)tempo duration:(int)duration
{
	NSString* name = [SoundManagerCore pauseName:tempo duration:duration];
	Buffer* buffer = [_buffersNotes objectForKey:name];
	
	return buffer;
	
}



- (Buffer*)rhythmBuffer:(int)rhythm tempo:(int)tempo variation:(int)variation
{
	NSString* name = [SoundManagerCore rhythmName:rhythm tempo:tempo variation:variation];
	Buffer* buffer = [_buffersRhythms objectForKey:name];
	
	return buffer;
}



- (void)stopNotes{
	
}


- (void)playRhythm:(int)rhythm tempo:(int)tempo variation:(int)variation loop:(BOOL)loop;{
	
	NSString* completeRhythmFilename = [NSString stringWithFormat:@"%d_%d_%d", rhythm, tempo, variation]; 
	
	Source* source = [self nextAvailableSource];
	[source playBuffer:[_buffersRhythms valueForKey:completeRhythmFilename] withName:completeRhythmFilename loop:loop];	
	
}


- (void)stopRhythms{
	
	//	[self stopSounds];
}

#pragma mark -
#pragma mark General methods

- (void)setLoadSound:(BOOL)enable{
	
}


- (BOOL)isLoadingSound {
	
	return FALSE;
}


/*
 Returns the next available source. If the source is not available, then
 it should use the source
 */
- (Source*)nextAvailableSource
{
	// Check is there is any source available
	//	ALint state;
	for(int i=0;i < MAX_AL_SOURCES; i++)
	{
		Source* source = [_soundSources objectAtIndex:i];
		
		if ([source isAvailable])
		{
			return source;
		}
	}
	
	// No sources available, so the first to be played will be used;
	// search in
	time_t first = time(NULL); // Current time
	int sourcePos = 0;
	for(int i=0;i < MAX_AL_SOURCES; i++)
	{
		Source* source = [_soundSources objectAtIndex:i];
		
		if([source timeLastUsed] < first) // if used before
		{
			first = [source timeLastUsed];
			sourcePos = i; // source position
		}
	}
	return [_soundSources objectAtIndex:sourcePos];
}


- (void) addBufferToDictionaryWithKey:(Buffer*)buffer dictionary:(NSMutableDictionary*)dictionary key:(NSString*)key
{
	[dictionary setValue:buffer forKey:key];	
}


/*
 Test if a sound is loaded with the \a name
 */
- (BOOL) isSoundLoaded:(NSString*) name
{
	return ([_buffers objectForKey:name] != nil);
}


- (BOOL) isNoteLoaded:(NSString*) name
{
	return ([_buffersInstrument objectForKey:name] != nil);
}


- (BOOL) isRhythmLoaded:(NSString*) name{
	
	return ([_buffersRhythms objectForKey:name] != nil);
}


#pragma mark -
#pragma mark Class methods

+ (ALvoid*)noteData:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int)octave{
	
	return nil;
}


+ (ALvoid*)rhythmData:(int)rhythm tempo:(int)tempo variation:(int)variation{
	
	
	//	NSString* rhythmName = [self rhythmName:rhythm tempo:tempo variation:variation];
	//	Buffer* rhythmBuffer = [_buffers objectForKey:rhythmName];
	//	
	//	return [rhythmBuffer data];
	
	return nil;
}

/**
 Convert all the variables from a pause to a single string to be used to identify the sound
 */
+ (NSString*) pauseName:(int)tempo duration:(int) duration
{
	return [NSString stringWithFormat:@"pause_%d_%d", tempo, duration];
}


/*
 Convert all the variables from a rhythm to a single string to be used to identify the sound
 */
+ (NSString*) rhythmName:(int) rhythm tempo:(int) tempo variation:(int) variation
{
	return [NSString stringWithFormat:@"%d_%d_%d", rhythm, tempo, variation];
}


/**
 Convert all the variables from a note to a single string to be used to identify the sound
 */
+ (NSString*) noteName:(int) instrument tempo:(int) tempo height:(int) height duration:(int) duration octave:(int) octave
{
	return [NSString stringWithFormat:@"%d_%d_%d_%d_%d", instrument, tempo, duration, octave, height];
}


/*
 Test if there are OpenAL errors. If there are write them to the console.
 */
+ (BOOL)checkOpenALErrors
{
	int alError = alGetError();
	switch(alError)
	{
		case AL_NO_ERROR:
			return NO;
		case AL_INVALID_NAME:
			NSLog( @"[SoundManager::error] Error: a bad name (ID) was passed to an OpenAL function" );
			return YES;
		case AL_INVALID_ENUM:
			NSLog( @"[SoundManager::error] Error: an invalid enum value was passed to an OpenAL function" );
			return YES;
		case AL_INVALID_VALUE:
			NSLog( @"[SoundManager::error] Error: an invalid value was passed to an OpenAL function" );
			return YES;
		case AL_INVALID_OPERATION:
			NSLog( @"[SoundManager::error] Error: the requested operation is not valid" );
			return YES;
		case AL_OUT_OF_MEMORY:
			NSLog( @"[SoundManager::error] Error: the requested operation resulted in OpenAL running out of memory" );
			return YES;
	}
	
	return YES;
}


- (void) removeObjectsWithPrefix:(NSString*)prefix dictionary:(NSMutableDictionary*)dictionary
{
	NSArray* keys = [dictionary allKeys];
	
	for(int i = 0; i < [keys count]; i++)
	{
		NSString* key = (NSString*) [keys objectAtIndex:i];
		
		if( [key hasPrefix:prefix] )
		{
			[dictionary removeObjectForKey:key];
			
			// TODO check if the release is run when removing form the dictionary
			// id obj = [dictionary objectForKey:key];
			// [obj release];
		}
	}	
}




- (void) releaseObjectsWithPrefix:(NSString*)prefix dictionary:(NSMutableDictionary*)dictionary
{
	NSArray* keys = [dictionary allKeys];
	
	for(int i = 0; i < [keys count]; i++)
	{
		NSString* key = (NSString*) [keys objectAtIndex:i];
		
		if( [key hasPrefix:prefix] )
		{			
			[dictionary removeObjectForKey:key];
			
			// TODO check if the release is run when removing form the dictionary
			// id obj = [dictionary objectForKey:key];
			// [obj release];
		}
	}
}

@end
