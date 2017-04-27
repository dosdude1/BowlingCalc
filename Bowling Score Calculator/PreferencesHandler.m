//
//  PreferencesHandler.m
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/19/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import "PreferencesHandler.h"

@implementation PreferencesHandler

-(id)init
{
    [self loadPrefs];
    return self;
}
+(PreferencesHandler *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static PreferencesHandler *sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}
-(void)writeData
{
    [prefs writeToFile:plistPath atomically:YES];
}
-(void)loadPrefs
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    plistPath = [paths.firstObject stringByAppendingPathComponent:@"preferences.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        prefs=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    else
    {
        prefs = [[NSMutableDictionary alloc] init];
    }
}
-(void)setShouldAutoReloadGame:(BOOL)shouldReload
{
    [prefs setObject:[NSNumber numberWithBool:shouldReload] forKey:@"shouldAutoReloadData"];
    [self writeData];
}
-(BOOL)shouldAutoReloadGame
{
    return [[prefs objectForKey:@"shouldAutoReloadData"] boolValue];
}
@end
