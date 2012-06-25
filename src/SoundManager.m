//
//  SoundManger.m
//

#import "SoundManager.h"
#import "SoundManagerCore.h"
#import "SynthesizeSingleton.h"

@implementation SoundManager

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(SoundManager)


#pragma mark -
#pragma mark Initializations

- (id)init
{
	if(self == [self initWithSettings:nil])
	{
		
	}
	
	return self;
}


- (id)initWithSettings:(NSUserDefaults*)defaults
{
	if(self == [super init])
	{
		_core = [[SoundManagerCore alloc] initWithSettings:defaults];
		
		if( _core == nil )
		{
			[self release];
			return nil;
		}
		
		_core.signalsEnabled = TRUE;
	}
	
	return self;
}


- (void) dealloc
{	
	[_core release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark Paths methods
/*
 Set the paths
 */
- (void) setSoundsPath:(NSString*) path
{
	[_core setSoundsPath:path];
}


- (void) setInstrumentsPath:(NSString*) path
{
	[_core setInstrumentsPath:path];
}


- (void) setRhythmsPath:(NSString*) path
{
	[_core setRhythmsPath:path];
}


#pragma mark -
#pragma mark Loading methods

- (void)setLoadIfNecessary:(BOOL)load
{
	[_core setLoadIfNecessary:load];
}


- (BOOL) loadSound:(NSString*) resource
{
	//TODO
	return [_core loadSound:resource name:resource];
}

- (void) setSoundVolume:(NSString*)resource volume:(float)aVolume
{
    [_core setSoundVolume: resource volume:aVolume];
}


- (void) releaseSound:(NSString*) name
{
	[_core releaseSound:name];
}


- (void) releaseAllSounds
{
	[_core releaseAllSounds];
}

#pragma mark -
#pragma mark Instruments/Rhythms load/release 
/*
 Load all notes from a instrument with a tempo to memory
 */

- (BOOL)loadInstruments
{
	//TODO
	if( ![self loadInstrument:Instrument_PIANO] )
	{	
		return NO;
	}
	if( ![self loadInstrument:Instrument_FLUTE] )
	{	
		return NO;
	}
	if( ![self loadInstrument:Instrument_VIOLIN] )
	{	
		return NO;
	}
	if( ![self loadInstrument:Instrument_XYLOPHONE] )
	{
		return NO;
	}
	
	return [self loadInstrument:Instrument_TRUMPET];
}


- (BOOL)loadInstrument:(int)instrument
{
	[self loadInstrument:instrument tempo:120];
	[self loadInstrument:instrument tempo:160];
	[self loadInstrument:instrument tempo:200];
	
	// TODO check if the load of each tempo went well.
	return YES;
}

- (BOOL)loadPauses:(int)tempo
{
	[_core loadPauses:tempo];
	
	return YES;
}

- (BOOL)loadPause:(int)tempo duration:(int)duration
{
	[_core loadPause:tempo duration:duration];
	
	return YES;
}

- (BOOL) loadInstrument:(int)instrument tempo:(int)tempo
{
	return [_core loadInstrument:instrument tempo:tempo];
}


- (BOOL)loadNote:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int)octave
{
	return [_core loadNote:instrument tempo:tempo height:height duration:duration octave:octave];
}

- (BOOL)loadNoteWithFilename:(NSString*)filename
{
	return [_core loadNoteWithFilename:filename];

}


- (BOOL)loadRhythms
{
	[self loadRhythm:1];
	[self loadRhythm:2];
	[self loadRhythm:3];
	[self loadRhythm:4];
	[self loadRhythm:5];
	
	
	return YES;
}


- (BOOL)loadRhythm:(int)rhythm
{
	[self loadRhythm:rhythm tempo:120];
	[self loadRhythm:rhythm tempo:160];
	[self loadRhythm:rhythm tempo:200];
	
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
 Load a single Rhytm variation
 */
- (BOOL)loadRhythm:(int)rhythm tempo:(int)tempo variation:(int)variation
{
	return [_core loadRhythm:rhythm tempo:tempo variation:variation];
}


#pragma mark -
#pragma mark Release methods

- (void) releaseInstruments
{
	[_core releaseInstruments];
}


- (void) releaseInstrument:(int)instrument
{
	[_core releaseInstrument:instrument];
}


- (void) releaseInstrument:(int)instrument tempo:(int)tempo
{
	[_core releaseInstrument:instrument tempo:tempo];
}


- (void) releaseRhythm:(int)rhythm tempo:(int)tempo
{
	[_core releaseRhythm:rhythm tempo:tempo];
}


- (void) releaseRhythm:(int) rhythm
{
	[_core releaseRhythm:rhythm];
}


- (void) releaseRhythms
{
	[_core releaseRhythms];
}


#pragma mark -
#pragma mark Sound Playing methods

- (BOOL) playSound:(NSString*) name
{
	[_core playSound:name loop:NO];
	
	return TRUE;
}


- (BOOL) playSound:(NSString*)name loop:(BOOL) loop
{
	[_core playSound:name loop:loop];
	return TRUE;
}


- (void) stopSound:(NSString*) name
{
	[_core stopSound:name];
}


- (void) stopSounds
{
	[_core stopSounds];
}

- (ALfloat)getSoundDuration:(NSString*)aName
{
    return [_core getSoundDuration:aName];
}


- (BOOL)isSoundPlaying{
	
	return [_core isSoundPlaying];	
}


- (BOOL)isSoundPlaying:(NSString*)name {
	
	return [_core isSoundPlaying:name];
}


- (BOOL)isSoundStopped:(NSString*)name{
	
	return [_core isSoundStopped:name];
	
}

//- (void)setSoundVolume:(NSString*)name volume:(float)volume;
//- (float)soundVolume:(NSString*) name;

- (void)setVolume:(float)aVolume
{
    _core.volume = aVolume;
}

#pragma mark -
#pragma mark Melody, Rhythms and Notes methods

- (BOOL)loadMelodySounds:(Melody*)melody{
	
	
	[_core loadMelody:melody];
	return FALSE;
}


- (BOOL)playMelody:(Melody*)melody
{
	return [_core playMelody:melody loop:FALSE];
}

- (BOOL)playMelody:(Melody*)melody loop:(BOOL)loop{
	
	return [_core playMelody:melody loop:loop];
	_isMelodyPlaying = TRUE;
}


- (void)stopMelody{
	
	[_core stopMelody];
	_isMelodyPlaying = FALSE;
	
}

- (void)unqueueBuffers {
	[_core unqueueBuffers];
}

- (void)stopMelody:(Melody*)melody{
	[_core stopMelody];
	_isMelodyPlaying = FALSE;
}


- (BOOL)isMelodyPlaying{
	
	return [_core isMelodyPlaying];
}
- (void)isMelodyPlaying:(BOOL)isMelodyPlaying
{    
    _isMelodyPlaying = isMelodyPlaying;
}

- (void)playNoteWithFilename:(NSString*)filename loop:(BOOL)loop {
	[_core playNoteWithFilename:filename loop:loop];
}


- (void)playNote:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int)octave{
	[_core playNote:instrument tempo:tempo height:height duration:duration octave:octave loop:FALSE];
}


- (void)stopNotes{
	
	[_core stopNotes];
}

- (void)playRhythm:(int)rhythm tempo:(int)tempo variation:(int)variation loop:(BOOL)loop{
	[_core playRhythm:rhythm tempo:tempo variation:variation loop:loop];
}

- (BOOL) isSoundLoaded:(NSString*) name{
	[_core isSoundLoaded:name];
	return TRUE;
}

-(void)setSignalsEnabled:(BOOL)aValue{
	_core.signalsEnabled = aValue;
}

-(BOOL)getSignalsEnabled{
	return _core.signalsEnabled;
}


- (NSString*)getLoadingPath{
    return _core.loadingPath;
}




@end
