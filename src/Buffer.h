//
//  Buffer.h
//
#import <Foundation/Foundation.h>
#import "Macros.h"

@interface Buffer : NSObject
{
	ALuint   _id;
	int      _size;
	float    _volume;
	ALvoid*  _data;
}

- (id)init;

- (id)init:(CFURLRef) soundFileURL;

- (void)dealloc;

- (NSString*)description;

- (void)setVolume:(float) volume;
- (float)volume;

- (ALvoid*)data;
- (int)size;

- (ALuint)bufferId;

- (ALfloat)durationOfBuffer:(ALuint)aBufferId;

@end
