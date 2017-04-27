//
//  PreferencesHandler.h
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/19/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferencesHandler : NSObject
{
    NSMutableDictionary *prefs;
    NSString *plistPath;
}


/*! Shared object */
+(PreferencesHandler *)sharedInstance;


/*!
 Set the "should auto reload game" preferences property
 
 @param shouldReload A true or false value representing whether or not to reload the current game
 */
-(void)setShouldAutoReloadGame:(BOOL)shouldReload;


/*!
 Retrieve the vlaue for the "should auto reload game" preferences property
 
 @return A true or flase value representing whether or not to reload the current game
 */
-(BOOL)shouldAutoReloadGame;


@end
