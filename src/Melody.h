//
//  Melody.h
//

#ifndef MELODY
#define MELODY

#import <Foundation/Foundation.h>
#import "Macros.h"
#import "CnotiAudio.h"
#import "Note.h"

#define NUM_AVAILABLE_RHYTHMS 6
#define NUM_AVAILABLE_INSTRUMENTS 6
#define MAX_RHYTHMS 3
#define MAX_INSTRUMENTS 1

@class Staff;

/**
 Class to represent a Melody of Notes
 */
@interface Melody : NSObject {
	
	NSString* name;
	enum EnumInstrument instrument;
	enum EnumTempo tempo;
	enum EnumTempo tempoOld;
	NSMutableArray* notesList;
    NSMutableArray* rhythms;
	NSString* voiceTrack;
	int numberOfNotes;
	int duration;
	int date;
	BOOL isChanged;
  	BOOL playRhythms;
    BOOL beenSaved;

	Staff* sharedStaff;
}

//SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(Melody);

@property (assign) NSString* name;
@property enum EnumTempo tempo;
@property enum EnumTempo tempoOld;
@property int date;
@property (assign) NSString* voiceTrack;
@property enum EnumInstrument instrument;
@property (assign) NSMutableArray* notesList;
@property (assign) NSMutableArray* rhythms;
@property (readwrite) int numberOfNotes;
@property (readwrite) BOOL isChanged;
@property (readwrite) BOOL beenSaved;
@property (readwrite) BOOL playRhythms;
@property int duration;

- (id) init: (NSString*)aMelodyName
 instrument: (enum EnumInstrument)aInstrument
	  tempo:(enum EnumTempo)aTempo;

- (BOOL)addNote: (Note*)aNote;
- (BOOL)removeLastNote;
- (BOOL)clear;
- (BOOL)setRhythmVariation: (enum EnumRhythm)aRhythm 
				 variation: (int)aVariation;
- (int)rhythmVariation: (enum EnumRhythm)aRhythm;

- (Note*)note: (int)aPos;
- (void)printMelody;
- (BOOL)addNote: (enum EnumNote)aNote
	   duration:(enum EnumDuration)aDuration
		 octave:(int)aOctave;

- (int)numberOfSelectedRhythms;

@end

#endif
