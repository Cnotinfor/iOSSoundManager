//
//  Note.m
//

#import "Note.h"


@implementation Note

@synthesize octave, note, duration;

/**
 Initialize a new Note Object
 @param aNote The note name
 @param aDuration The note duration
 @param aOctave The octave of the note
 */
- (id)init:(enum EnumNote)aNote
  duration:(enum EnumDuration)aDuration
	octave:(int)aOctave {
	
	self = [super init];
	
	if (self) {		
		duration = aDuration;
		note = aNote;
		octave = aOctave;
	}
	
	return self;
}

/**
 Get note description
 @returns A NSString with a description of the name
 */
- (NSString*)getNoteDescription
{
	NSString* res;
	res = [NSString stringWithFormat:@"Note: %d - Duration: %d - Octave: %d", note, duration, octave];
	return res;
}

/**
 Get note filename (without .wav extension) without the instrument and tempo prefixes
 @returns A NSString with filename
 */
- (NSString*)filename
{
	NSString* res;
	
	if (note!=Note_PAUSE) {
		res = [NSString stringWithFormat:@"%d_%d_%d", duration, octave, note];
	}
	else {
		res = [NSString stringWithFormat:@"%d", duration];
	}
		
	return res;
}


/**
 Get the Note String
 @returns The Note in a String format
 */
- (NSString*)getNoteString

{		
	NSString* str = [self enumNoteToString: note];
	return str;
}

/**
 Get the Note duration
 @returns The Note duration (number) in a String format
 */
- (NSString*)getNoteDuration

{		
	NSString* str = [self enumDurationToString: duration];
	return str;
}

#pragma mark Auxiliary Functions

- (NSString*)enumNoteToString:(int)formatType {
    NSString *result = nil;
	
	//do_agudo
	
    switch(formatType) {
        case Note_DO:
            if (octave == 3) {
                result = @"do";                
            }
            else {
                result = @"do_agudo";  
            }
            break;
        case Note_RE:
            result = @"re";
            break;
        case Note_MI:
            result = @"mi";
            break;
        case Note_FA:
            result = @"fa";
            break;
		case Note_SOL:
            result = @"sol";
            break;
		case Note_LA:
            result = @"la";
            break;
		case Note_SI:
            result = @"si";
            break;
			//TODO - Missing Pause Sprites
		case Note_PAUSE:
            result = @"pause";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    return result;
}


- (NSString*)enumDurationToString:(int)formatType {
    NSString *result = nil;
	
    switch(formatType) {
        case Duration_CROTCHET:
            result = @"32";
            break;
        case Duration_MINIM:
            result = @"64";
            break;
        case Duration_MINIM_DOTTED:
            result = @"96";
            break;
        case Duration_SEMIBREVE:
            result = @"128";
			break;
        case Duration_UNKNOWN_DURATION:
            result = @"UNKNOWN_DURATION";
			break;
		default:
            result = @"UNKNOWN_DURATION";
        }
	return result;
}


- (void)dealloc
{
	[super dealloc];
}

@end
