//
//  SoundManger.h
//  SoundManagerIOS
//
//  Created by Tiago Correia on 11/03/15.
//  Copyright 2011 Cnotinfor. All rights reserved.
//

#import "SoundManagerCore.h"
#import "SynthesizeSingleton.h"



// Signals for the sound manager
// To be used by the Notification Center
#define SIGNAL_SOUND_STARTED     @"Sound Started"
#define SIGNAL_SOUND_FINISHED    @"Sound Finished"
#define SIGNAL_NOTE_STARTED      @"Note Started"
#define SIGNAL_NOTE_FINISHED     @"Note Finished"
#define SIGNAL_MELODY_FINISHED   @"Melody Finished"
#define SIGNAL_MELODY_STARTED    @"Melody Started"

// Keys for the values that can be included in the dictionary
// when sending signals to the Notication Center
#define KEY_SOUND_NAME           @"Sound"
#define KEY_NOTE_POSITION        @"Note Position"



@interface SoundManager: NSObject
{
	SoundManagerCore*   _core; // To access private stuff from the Sound Manager

	//TODO
	BOOL signalsEnabled;
	BOOL isMelodyPlaying;
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SoundManager);


@property (readwrite) BOOL signalsEnabled;
@property (readwrite) BOOL isMelodyPlaying;


- (id)init;
- (id)initWithSettings:(NSUserDefaults*)defaults;

- (void)dealloc;

- (void)setSoundsPath:(NSString*)path;
- (void)setInstrumentsPath:(NSString*)path;
- (void)setRhythmsPath:(NSString*)path;

- (void)setLoadIfNecessary:(BOOL)load;

- (BOOL)loadSound:(NSString*)resource;

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

- (void)stopSounds;

- (BOOL)isSoundPlaying;
- (BOOL)isSoundPlaying:(NSString*)name;
- (BOOL)isSoundStopped:(NSString*)name;

//- (void)setSoundVolume:(NSString*)name volume:(float)volume;
//- (float)soundVolume:(NSString*) name;


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

- (BOOL) isSoundLoaded:(NSString*) name;



//- (NSString*)errorMessage;
//- (int)error;



@end
