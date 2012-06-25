//
//  SoundManger.h
//

#import <Foundation/Foundation.h>
#import "Macros.h"
#import "SoundManagerCore.h"
#import "SynthesizeSingleton.h"



@interface SoundManager: NSObject
{
	SoundManagerCore*   _core; // To access private stuff from the Sound Manager

	//TODO
	BOOL signalsEnabled;
	BOOL _isMelodyPlaying;
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SoundManager);


@property (readwrite, setter = isMelodyPlaying:, getter = isMelodyPlaying) BOOL isMelodyPlaying;


- (id)init;
- (id)initWithSettings:(NSUserDefaults*)defaults;

- (void)dealloc;

- (void)setSoundsPath:(NSString*)path;
- (void)setInstrumentsPath:(NSString*)path;
- (void)setRhythmsPath:(NSString*)path;

- (void)setLoadIfNecessary:(BOOL)load;

- (BOOL)loadSound:(NSString*)resource;

- (void) setSoundVolume:(NSString*)resource volume:(float)aVolume;

- (void)releaseSound:(NSString*)name;
- (void)releaseAllSounds;

- (BOOL)loadInstruments;
- (BOOL)loadInstrument:(int)instrument;
- (BOOL)loadPauses:(int)tempo;
- (BOOL)loadPause:(int)tempo duration:(int)duration;
- (BOOL)loadInstrument:(int)instrument tempo:(int)tempo;
- (BOOL)loadNote:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int)octave;
- (BOOL)loadNoteWithFilename:(NSString*)filename;
- (BOOL)loadRhythms;
- (BOOL)loadRhythm:(int)rhythm;
- (BOOL)loadRhythm:(int)rhythm tempo:(int)tempo;
- (BOOL)loadRhythm:(int)rhythm tempo:(int)tempo variation:(int)variation;

- (void)releaseInstruments;
- (void)releaseInstrument:(int)instrument;
- (void)releaseInstrument:(int)instrument tempo:(int) tempo;
- (void)releaseRhythms;
- (void)releaseRhythm:(int)rhythm;
- (void)releaseRhythm:(int)rhythm tempo:(int)tempo;


- (BOOL)playSound:(NSString*)name;
- (BOOL)playSound:(NSString*)name loop:(BOOL)loop;
- (void)stopSound:(NSString*)name;
- (void)unqueueBuffers;

- (void)stopSounds;
- (ALfloat)getSoundDuration:(NSString*)aName;

- (BOOL)isSoundPlaying;
- (BOOL)isSoundPlaying:(NSString*)name;
- (BOOL)isSoundStopped:(NSString*)name;

//- (void)setSoundVolume:(NSString*)name volume:(float)volume;
//- (float)soundVolume:(NSString*) name;

- (void)setVolume:(float)aVolume;

- (BOOL)loadMelodySounds:(Melody*)melody;
- (BOOL)playMelody:(Melody*)melody;
- (BOOL)playMelody:(Melody*)melody loop:(BOOL)loop;
- (void)stopMelody;
- (void)stopMelody:(Melody*)melody;

- (BOOL)isMelodyPlaying;
//- (int)isNotePlaying;

- (void)playNoteWithFilename:(NSString*)filename loop:(BOOL)loop;
- (void)playNote:(int)instrument tempo:(int)tempo height:(int)height duration:(int)duration octave:(int)octave;
- (void)stopNotes;

- (void)playRhythm:(int)rhythm tempo:(int)tempo variation:(int)variation loop:(BOOL)loop;

- (BOOL)isSoundLoaded:(NSString*) name;

- (void)setSignalsEnabled:(BOOL)aValue;
- (BOOL)getSignalsEnabled;

- (NSString*)getLoadingPath;

//- (NSString*)errorMessage;
//- (int)error;


@end
