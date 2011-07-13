//
//  SoundManagerIOS_TestAppDelegate.m
//  SoundManagerIOS_Test
//
//  Created by Gonçalo Rodrigues on 11/03/23.
//  Copyright 2011 Universidade de Coimbra. All rights reserved.
//

#import "SoundManagerIOS_TestAppDelegate.h"

#import "SoundManager.h"

@implementation SoundManagerIOS_TestAppDelegate

@synthesize window;

-(id)init {

	[super init];
	
	labelField = [NSString stringWithString:@""];
	soundManager = [[SoundManager alloc] init];

//	[soundManager setSoundsPath:@"/sfx/"];
//	[soundManager setInstrumentsPath:@"/Instruments/"];
//	[soundManager setRhythmsPath:@"/Rhythms/"];
//	[soundManager loadInstrument:Instrument_FLUTE tempo:Tempo_Tempo120];

	
	NSLog(@"loadSound: %d",[soundManager loadSound:@"sound1"]);
	
//	[soundManager loadNote:2 tempo:120 height:2 duration:32 octave:3];

	return self;
}


-(IBAction)playSound:(id)sender{

	[labelField setText:@"PlaySound"];	
	[soundManager playSound:@"sound1"];
	
	NSLog(@"%d", [soundManager isSoundPlaying]);
}

-(IBAction)stopSound:(id)sender{
	
	[labelField setText:@"StopSound"];
	[soundManager stopSound:@"sound1"];
	
	NSLog(@"stopSound: %d", [soundManager isSoundPlaying]);
}

-(IBAction)removeSound:(id)sender{

	[labelField setText:@"RemoveSound"];
	[soundManager releaseSound:@"sound1"];
	
}

-(IBAction)playNote:(id)sender{
	[labelField setText:@"PlayMelody"];
	
	NSLog(@"Let's play the melody.");
//	[soundManager playNote:2 tempo:120 height:2 duration:32 octave:3];
	[soundManager playNote:2 tempo:120 height:2 duration:64 octave:3];

}

-(IBAction)playMelody:(id)sender{
	[labelField setText:@"PlayMelody"];
	
	
	Melody* melody = [[Melody alloc] init:@"Melodia" instrument:Instrument_FLUTE tempo:Tempo_Tempo120];
	[melody addNote:Note_DO duration:Duration_MINIM_DOTTED octave:3];
	[melody addNote:Note_RE duration:Duration_MINIM_DOTTED octave:3];
	[melody addNote:Note_MI duration:Duration_MINIM_DOTTED octave:3];
	
	[[melody rhythms] insertObject:[NSNumber numberWithInt:1] atIndex:0];
	[[melody rhythms] insertObject:[NSNumber numberWithInt:2] atIndex:1];

	[soundManager loadMelodySounds:melody];
	[soundManager playMelody:melody loop:FALSE];
	
	NSLog(@"Let's play the melody.");
//	[soundManager playNote:2 tempo:120 height:2 duration:32 octave:3];
}


-(IBAction)stopMelody:(id)sender{
	
	NSLog(@"stopMelody");
	[soundManager stopMelody];

}

-(IBAction)releaseInstruments:(id)sender{

	NSLog(@"Let's release all sounds.");
	[soundManager releaseInstruments];
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
