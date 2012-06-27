//
//  Melody.m
//

#import "Melody.h"

@implementation Melody

/**
 Setters and Getters using properties
 */
@synthesize name;
@synthesize instrument;
@synthesize tempo;
@synthesize tempoOld;
@synthesize notesList;
@synthesize voiceTrack;
@synthesize numberOfNotes;
@synthesize duration;
@synthesize rhythms;
@synthesize date;
@synthesize isChanged;
@synthesize playRhythms;
@synthesize beenSaved;

/**
 Initialize a new Melody Object with default settings
 @returns Melody object with default settings
 */
- (id) init{
	if( self = [super init] ) {
		name = [[NSString alloc] initWithString:@"defaultMelodyName"];
		
		instrument = (enum EnumInstrument) Instrument_FLUTE;
		tempo = (enum EnumTempo) Tempo_Tempo160;

		notesList = [[NSMutableArray alloc] init];
		voiceTrack = NULL;
		
		numberOfNotes = 0;
		duration = 0;
		
		rhythms = [[[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInt:-1],
				   [NSNumber numberWithInt:-1],
				   [NSNumber numberWithInt:-1],
				   [NSNumber numberWithInt:-1],
				   [NSNumber numberWithInt:-1],
				   [NSNumber numberWithInt:-1], nil] retain];
		
		isChanged = FALSE;
        playRhythms = TRUE;
		
	}
	return self;
}


/**
 Initialize a new Melody Object with a specific melody name, instrument and tempo
 @param aMelodyName Name of the melody
 @param aInstrument Instrument of the melody
 @param aTempo Tempo of the melody
 @returns Melody object
 */
- (id) init: (NSString*)aMelodyName
 instrument: (enum EnumInstrument)aInstrument
	  tempo:(enum EnumTempo)aTempo
{
	[self init];
	
	name = aMelodyName;
	instrument = aInstrument;
	tempo = aTempo;
	notesList = [[NSMutableArray alloc] init];
	voiceTrack = NULL;
	isChanged = FALSE;
			
	return self;
}


/**
 Add a note to the melody.
 @param aNote Note object to add to melody
 */
- (BOOL)addNote:(Note*)aNote {
	[notesList addObject:aNote];
	numberOfNotes++;
	
	// Update the compass
	duration+=aNote.duration/32;
	
	isChanged = TRUE;
	return TRUE;
}


/**
 Add a note to the melody.
 @param aNote Note to add to melody
 @param aDurations Duration of note
 @param aOctave Octave of note
 */
- (BOOL) addNote: (enum EnumNote)aNote
		duration:(enum EnumDuration)aDuration
		  octave:(int)aOctave
{
	Note* note;
	note = [[Note alloc] init:(int)aNote duration:(int)aDuration octave:aOctave];
	[notesList addObject:note];

	numberOfNotes++;
	
	// Update the compass
	duration+=aDuration/32;
	
	[note release];
	
	isChanged = TRUE;
	
	return TRUE;
}


/**
 Remove last note from melody.
 */
- (BOOL) removeLastNote {
	
	if(numberOfNotes>=0) {
		
		Note* noteToRemove = [notesList objectAtIndex:[notesList count]-1];
		duration-=noteToRemove.duration/32;
		
		[notesList removeLastObject];
		numberOfNotes--;
	}
	isChanged = TRUE;
	return TRUE;
}


/**
 Clear the melody array by removing all (Note) objects.
 */
- (BOOL) clear {
	[notesList removeAllObjects];
	isChanged = FALSE;
	numberOfNotes=0;
	duration=0;
	return TRUE;
}


/**
 Set rhythm variation of a specific rhythm
 */
- (BOOL) setRhythmVariation: (enum EnumRhythm)aRhythm 
				  variation: (int)variation {
	
	[rhythms replaceObjectAtIndex:aRhythm withObject:[NSNumber numberWithInt:variation]];
	
	isChanged = TRUE;
	
	return TRUE;
}


/**
 Get the rhythm variation by passing rhythm name
 */
- (int) rhythmVariation: (enum EnumRhythm)aRhythm {
	return [[rhythms objectAtIndex:aRhythm] intValue];
}


- (int)numberOfSelectedRhythms {
	int counter = 0;
	
	for (int i=0; i<(int)[rhythms count]; i++) {
		if ([[rhythms objectAtIndex:i] intValue]!=-1) {
			counter++;
		}
	}
	return counter;
}

/**
 Get a Note at a specific position
 */
- (Note*) note: (int)aPos {
	return [notesList objectAtIndex:aPos];
}


/**
 Print melody to console
 */
- (void) printMelody {
//	Note* item;

	int counter=0;
	NSNumber* num;
	for (num in rhythms) {
		counter++;
	}
}


- (void)dealloc {
	[rhythms release];
	[notesList release];
	[super dealloc];
}

@end
