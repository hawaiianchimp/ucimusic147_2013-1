//
//  MUS147Voice_Synth.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 4/26/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Voice_Synth.h"

#import "MUS147AQPlayer.h"

@implementation MUS147Voice_Synth

//*****************************************************************
//Sean Burke made the initWithFreq function which creates a voice with
// a frequency
//*****************************************************************
-(id)initWithFreq:(UInt64)frequency
{
    
    self = [super init];
    amp = 0.50;
    speed = 1.;
    freq = frequency;
    return self;
}

-(void)addToAudioBuffer:(Float64*)buffer :(UInt32)num_samples
{
    if(!playing)
    {
        return;
    }
    // compute normalized angular frequency
    Float64 deltaNormPhase = freq / kSR;
    
    // iterate through each element in the buffer
    for (UInt32 i = 0; i < num_samples; i++)
    {
        // assign value of sinusoid at phase position to buffer element
		buffer[i] += amp * sin(normPhase * 2 * M_PI);
        
        // advance the phase position
		normPhase += deltaNormPhase;
    }
}

@end
