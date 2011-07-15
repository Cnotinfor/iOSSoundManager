//
//  Source.h
//

#import <Foundation/Foundation.h>
#import "Macros.h"

#import "time.h"
#import "Buffer.h"

#import "NSThread+BlockExtensions.h"

@interface Source : NSObject {
	ALuint		_source;   // Source to play the sounds 
	time_t      _timeUsed;
	NSString*	_name;
    BOOL _emitSignal;
    
    ALfloat _duration;
    
    NSLock* _lock;
    
    NSThread* _thread;
}


@property (readonly, retain) NSString* name;
@property (readwrite, assign) BOOL emitSignal;


- (id)init;
- (void)dealloc;

- (BOOL)isPlaying;
- (BOOL)isStopped;
- (BOOL)isAvailable; //verify state of Source

- (BOOL)playBuffer:(Buffer*)buffer;
- (BOOL)playBuffer:(Buffer*)buffer withName:(NSString*)name;
- (BOOL)playBuffer:(Buffer*)buffer withName:(NSString*)name loop:(BOOL)loop;

- (void)checkSourceStateThread:(NSString*)name;

- (void)stop;

- (time_t)timeLastUsed;

- (void)dealloc;

@end
