//
//  GameManager.h
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/20/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject
{
    NSString *gameDir;
}

/*! Shared object */
+(GameManager *)sharedInstance;


/*!
 Produces the names of all present saved games.
 
 @return An array of strings containing the name of each save file
 */
-(NSArray *)getSavedGameNames;


/*!
 Deletes a save file containg the specified name
 
 @param name The name of the save file to delete
 */
-(void)deleteSavedGameWithName:(NSString *)name;


/*!
 Produces the total score of a specified game
 
 @param name The name of the saved game to get the score for
 @return The score of the specified game
 */
-(int)getScoreForGameWithName:(NSString *)name;

@end
