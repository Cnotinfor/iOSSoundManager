//
//  SoundMangerCore.h
//

#import <Foundation/Foundation.h>
#import "Macros.h"
#import "time.h"
#import "Buffer.h"
#import "Melody.h"

#import "Source.h"

// Signals for the sound manager
// To be used by the Notification Center
#define SIGNAL_MELODY_FINISHED   @"MelodyFinished"
#define SIGNAL_MELODY_STARTED    @"MelodyStarted"

#define SIGNAL_SOUND_STARTED     @"SoundStarted"
#define SIGNAL_SOUND_FINISHED    @"SoundFinished"
#define SIGNAL_NOTE_STARTED      @"NoteStarted"
#define SIGNAL_NOTE_FINISHED     @"NoteFinished"

// Keys for the values that can be included in the dictionary
// when sending signals to the Notication Center
#define KEY_SOUND_NAME           @"Sound"
#define KEY_NOTE_POSITION        @"NotePosition"


#define MAX_AL_SOURCES 8 // Iphone supports 32. It can play MAX_AL_SOURCES sounds at the same time
#define NUM_MELODY_SOURCES 4 // At maximum in iPhone it plays 1 melody and 3 rhythms.



@interface SoundManagerCore: NSObject
{
	ALCcontext*      _context;				// Context in which all sounds will be played
	ALCdevice*       _device;					// Reference to the device to use when playing sounds

	ALuint           _sources[MAX_AL_SOURCES];   // Sources to play sounds
	
	ALuint           _melodySources[NUM_MELODY_SOURCES]; // Sources used to play a melody
	ALuint*          _melodyBuffers;
	int              _melodySourcesPlaying;

	// Dictionaries for the sound buffers
	NSMutableDictionary*       _buffers;
	NSMutableDictionary*       _buffersNotes;
	NSMutableDictionary*       _buffersRhythms;
	
	NSMutableDictionary*       _buffersInstruments;
	
	// Paths to use when loading sounds
	NSString*  _soundsPath;
	NSString*  _rhythmsPath;
	NSString*  _instrumentsPath;

	float             _rhythmsVolume[NUM_AVAILABLE_RHYTHMS];
	float             _instrumentsVolume[NUM_AVAILABLE_INSTRUMENTS];
	float             _volume;
	
	NSArray*          _soundSources;
	
	BOOL              _loadSounds; // If it is true, if a sound doens't exist, tries to load it.
	
	int _numberOfNotes;
	
	BOOL signalsEnabled;
	
//	NSThread* isMelodyPlayingThread;
}

@property (readonly) NSMutableDictionary* buffersNotes;
@property (readonly) NSMutableDictionary* buffersRhythms;

@property (readonly) NSMutableDictionary* buffersInstruments;

@property (readonly) NSString* loadingPath;
@property (readonly) NSString* notesPath;
@property (readonly) NSString* rhythmsPath;

@property (readwrite) float volume;

@property (readwrite) BOOL signalsEnabled;


// Inits
- (id)init;
- (id)initWithSettings:(NSUserDefaults*) defaults;

// Inits of variables
- (BOOL)initOpenAL;

- (BOOL)initSources;
- (BOOL)initBuffers;

- (BOOL) initVolumeFromSettings:(NSUserDefaults*) defaults;

// Releases
- (void)releaseOpenAL;
- (void)dealloc;

// Define loading paths
- (void)setSoundsPath:(NSString*)path;
- (void)setInstrumentsPath:(NSString*)path;
- (void)setRhythmsPath:(NSString*)path;

- (void)setLoadIfNecessary:(BOOL)load;

// Load sound resources
- (Buffer*) loadWave:(NSString*)resource path:(NSString*)path;

- (BOOL)loadSound:(NSString*)resource;
- (BOOL)loadSound:(NSString*)resource name:(NSString*)name;
- (void) setSoundVolume:(NSString*)resource volume:(float)aVolume;

- (BOOL)loadInstrument:(int)instrument tempo:(int)tempo;
- (BOOL)loadPauses:(int)tempo;
- (BOOL)loadPause:(int)tempo duration:(int)duration;
- (BOOL)loadNote:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int)octave;
- (BOOL)loadNoteWithFilename:(NSString*)filename;

- (BOOL)loadRhythm:(int)rhythm tempo:(int)tempo;
- (BOOL)loadRhythm:(int)rhythm tempo:(int)tempo variation:(int)variation;

- (void)releaseSound:(NSString*)name;
- (void)releaseAllSounds;
- (void)releaseInstrument:(int)instrument;
- (void)releasePauses:(int)tempo;
- (void)releaseInstrument:(int)instrument tempo:(int) tempo;
- (void)releaseInstruments;
- (void)releaseRhythm:(int)rhythm tempo:(int)tempo;
- (void)releaseRhythm:(int)rhythm;
- (void)releaseRhythms;

// Sound methods
- (void)playSound:(NSString*)name loop:(BOOL)loop;
- (BOOL)isSoundPlayingThread;
- (void)stopSound:(NSString*)name;
- (void)stopSounds;

- (ALfloat)getSoundDuration:(NSString*)name;

- (BOOL)isSoundPlaying;
- (BOOL)isSoundPlaying:(NSString*)name;
- (BOOL)isSoundStopped:(NSString*)name;

// Volume
//- (void)setSoundVolume:(NSString*)name volume:(float)volume;
//- (float)soundVolume:(NSString*) name;
//
//- (void)setVolume:(float)volume;
//- (float)volume;

// Melody
- (void)loadMelody:(Melody*)melody;
- (BOOL)playMelody:(Melody*)melody;
- (BOOL)playMelody:(Melody*)melody loop:(BOOL)loop;
- (void)stopMelody;
- (void)unqueueBuffers;

- (BOOL)isMelodyPlaying;
- (BOOL)isMelodyPlayingThread;
- (int)noteBeingPlayed;

// Play single 
- (void)playNoteWithFilename:(NSString*)filename loop:(BOOL)loop;
- (void)playNote:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int) octave loop:(BOOL)loop;
- (void)stopNotes;

- (void)playRhythm:(int)rhythm tempo:(int)tempo variation:(int)variation loop:(BOOL)loop;
- (void)stopRhythms;

//- (NSString*) errorMessage;
//- (int) error;

// If we make play of a sound and if it don't exists do load else don't do load
- (void)setLoadSound:(BOOL)enable;
- (BOOL)isLoadingSound;

- (Source*)nextAvailableSource;
- (void) addBufferToDictionaryWithKey:(Buffer*)buffer dictionary:(NSMutableDictionary*)dictionary key:(NSString*)key;

- (Buffer*)noteBuffer:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int) octave;
- (Buffer*)pauseBuffer:(int)tempo duration:(int)duration;
- (Buffer*)rhythmBuffer:(int)rhythm tempo:(int)tempo variation:(int)variation;

- (BOOL) isSoundLoaded:(NSString*) name;
- (BOOL) isNoteLoaded:(NSString*) name;
- (BOOL) isRhythmLoaded:(NSString*) name;

// Get the raw buffer data
+ (ALvoid*)noteData:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int)octave;
+ (ALvoid*)rhythmData:(int)rhythm tempo:(int)tempo variation:(int)variation;

+ (NSString*) pauseName:(int)tempo duration:(int) duration;
+ (NSString*) rhythmName:(int)rhythm tempo:(int)tempo variation:(int)variation;
+ (NSString*) noteName:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int)octave;

+ (BOOL)checkOpenALErrors;

- (void) removeObjectsWithPrefix:(NSString*)prefix dictionary:(NSMutableDictionary*)dictionary;
- (void) releaseObjectsWithPrefix:(NSString*)prefix dictionary:(NSMutableDictionary*)dictionary;

@end
