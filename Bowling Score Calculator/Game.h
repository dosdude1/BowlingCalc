//
//  Game.h
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/18/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! Object delegate */
@protocol GameDelegate <NSObject>
@optional
-(void)valueDidChangeAtFrame:(int)frame forRoll:(int)roll toValue:(NSString *)value;
@end

@interface Game : NSObject
{
    NSMutableArray *frames;
    BOOL isSavedGame;
}

/*! Object delegate property */
@property (nonatomic, strong) id <GameDelegate> delegate;


/*! Defult object initializer */
-(id)init;


/*! 
 Initialize this object with a saved game
 @param gameName The name of the game to load.
 */
-(instancetype)initWithSavedGame:(NSString *)gameName;


/*!
 Produces a string value represnting the score of a roll at a particular frame. This string is displayed to the user as the score value for a particular frame and roll.
 
 @param rollNum The roll number
 @param frameNum the frame number
 
 @return A string contining the visual representation of the score.
 */
-(NSString *)getValueForRoll:(int)rollNum atFrame:(int)frameNum;


/*!
 Set the score value for a particular roll in a particular frame
 
 @param value The string representation of a score value
 @param rollNum The roll number
 @param frameNum The frame number
 */
-(void)setValue:(NSString *)value forRoll:(int)rollNum atFrame:(int)frameNum;


/*!
 Produces the score based on the values of a specific frame
 
 @param frame The frame number
 @return The score for that frame
 */
-(int)getScoreForFrame:(int)frame;


/*!
 Produces the running total for all frames up to the specified one
 
 @param frame The frame number
 @return The running total at that frame
 */
-(int)getRunningTotalForFrame:(int)frame;


/*!
 Produces the valid inputs for a given roll at a given frame
 
 @param roll The roll number
 @param frame The frame number
 @return An array containing string respresentations of the valid score inputs
 */
-(NSArray *)getValidInputsForRoll:(int)roll atFrame:(int)frame;


/*!
 Serializes and saves this game
 
 @param saveName The desired save file name
 */
-(void)saveGameWithName:(NSString *)saveName;


/*!
 Loads this game with the contents of a save file
 
 @param name The name of the save file to load from
 */
-(void)loadGameWithName:(NSString *)name;


/*!
 Clear all contents of this game and set all values to 0.
 */
-(void)initEmptyGame;

@end
