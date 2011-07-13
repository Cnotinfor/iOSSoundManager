//
//  SoundManagerIOS_TestAppDelegate.h
//  SoundManagerIOS_Test
//
//  Created by Gonçalo Rodrigues on 11/03/23.
//  Copyright 2011 Universidade de Coimbra. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "SoundManager.h"

@interface SoundManagerIOS_TestAppDelegate : NSObject <UIApplicationDelegate> {

	IBOutlet UILabel *labelField;
	
	SoundManager* soundManager;
    
	UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

-(IBAction)playSound:(id)sender;
-(IBAction)stopSound:(id)sender;
-(IBAction)removeSound:(id)sender;

-(IBAction)playNote:(id)sender;
-(IBAction)playMelody:(id)sender;

-(IBAction)stopMelody:(id)sender;

-(IBAction)releaseInstruments:(id)sender;

@end

