//
//  MUS147Voice_Sample_SF.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/18/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Voice_Sample_SF.h"

@implementation MUS147Voice_Sample_SF

//*****************************************************************
//Sean Burke made the initWithFileName to easily create a voice with a file
// there is a warning, which I don't know how to fix, but it works!
//it comes from using CFStringRef and CFSTR. Not sure...
//*****************************************************************

-(id)initWithFile:(NSString*)filename
{
    self = [super init];
    env = [[MUS147Envelope alloc] init];
	env.attack = 0.50;
	env.release = 1.50;
    speed = 1;
    amp = 1;
    playing = NO;
    
    /* get a path to the sound file */
    /* note that the file name and file extension are set here */
    CFURLRef mSoundFileURLRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(),(__bridge CFStringRef)(filename),CFSTR("aif"),NULL);
    
    /* open the file and get the fileID */
    OSStatus result = noErr;
    result = AudioFileOpenURL(mSoundFileURLRef,kAudioFileReadPermission,0,&fileID);
    if (result != noErr)
        NSLog(@"AudioFileOpenURL exception %ld",result);
    
    return self;
}

-(void)dealloc
{
	/* close the file */
	OSStatus result = noErr;
	result = AudioFileClose(fileID);
	if (result != noErr)
		NSLog(@"AudioFileClose %ld",result);
}

-(void)addToAudioBuffer:(Float64*)buffer :(UInt32)num_samples
{
    if(!playing)
    {
        filePos = 0;
        return;
    }
    /* set up arguments needed by AudioFileReadPackets */
    UInt32 numReadPackets = num_samples * speed;
	UInt32 ioNumPackets = numReadPackets;
	SInt64 inStartingPacket = (SInt64)filePos; /* convert float to int */
	UInt32 outNumBytes = 0;
    
    /* read some data */
	OSStatus result = AudioFileReadPackets(fileID,NO,&outNumBytes,NULL,inStartingPacket,&ioNumPackets,fileBuffer);
	if (result != noErr)
		NSLog(@"AudioFileReadPackets exception %ld",result);
    
    if (ioNumPackets < numReadPackets)
    /* reset the filePos value to 0 to loop back to the beginning of the sound file */
        filePos = ioNumPackets;
    else
    /* advance the member variable filePos to know where to read from next time this method is called */
        filePos += ioNumPackets;
    
	/* convert the buffer of sample read from sound file into the app's internal audio buffer */
	for (UInt32 buf_pos = 0; buf_pos < num_samples; buf_pos++)
	{
		Float64 s = (SInt16)CFSwapInt16BigToHost(fileBuffer[(UInt32)(buf_pos * speed)]);
		buffer[buf_pos] += (amp * s) / INT16_MAX;
	}
}

@end
