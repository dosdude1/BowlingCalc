//
//  GameManager.m
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/20/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

-(id)init
{
    [self loadGames];
    return self;
}
+(GameManager *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static GameManager *sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}
-(void)loadGames
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    gameDir = [paths.firstObject stringByAppendingPathComponent:@"Games"];
}

-(NSArray *)getSavedGameNames
{
    NSArray *savedGames=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:gameDir error:nil];
    NSMutableArray *names=[[NSMutableArray alloc]init];
    for (NSString *s in savedGames)
    {
        NSString *name = [s substringToIndex:[s rangeOfString:@"."].location];
        if (![name isEqualToString:@"currentGame"] && [s rangeOfString:@"plist"].location != NSNotFound)
        {
            [names addObject:name];
        }
    }
    return names;
}
-(void)deleteSavedGameWithName:(NSString *)name
{
    NSString *gameFileDir=[gameDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:gameFileDir])
    {
        [[NSFileManager defaultManager] removeItemAtPath:gameFileDir error:nil];
    }
}
-(int)getScoreForGameWithName:(NSString *)name
{
    NSArray *game = [[NSArray alloc] initWithContentsOfFile:[gameDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]]];
    return [[[game objectAtIndex:9] objectForKey:@"runningTotal"] intValue];
}
@end
