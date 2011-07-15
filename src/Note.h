//
//  Note.h
//

#import <Foundation/Foundation.h>
#import "Macros.h"
#import "CnotiAudio.h"

/**
 Class to represent Notes
 */
@interface Note : NSObject {
	enum EnumNote note;
	enum EnumDuration duration;
	int octave;
}

@property (readonly) int octave;
@property (readonly) enum EnumDuration duration;
@property (readonly) enum EnumNote note;


- (id)init:(enum EnumNote)aNote
  duration:(enum EnumDuration)aDuration
	octave:(int)aOctave;

- (NSString*)getNoteDescription;
- (NSString*)filename;

- (NSString*)getNoteString;
- (NSString*)getNoteDuration;

- (NSString*)enumNoteToString:(int)formatType;
- (NSString*)enumDurationToString:(int)formatType;

- (void)dealloc;


@end
