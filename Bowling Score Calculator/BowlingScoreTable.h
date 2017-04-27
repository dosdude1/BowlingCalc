//
//  BowlingScoreTable.h
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/17/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameSelectionView.h"
#import "UIPopoverController+iPhone.h"
#import "Game.h"
#import "PreferencesHandler.h"
#import "LoadGameTable.h"

@interface BowlingScoreTable : UITableViewController <FrameSelectionDelegate, GameDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate, LoadGameDelegate>
{
    FrameSelectionView *frameSelectionView;
    UIPopoverController *popController;
    NSMutableArray *tableCells;
    NSMutableArray *frames;
    Game *game;
    PreferencesHandler *prefs;
    LoadGameTable *loadGameTable;
    int selectedRow;
    int selectedButton;
    UINavigationController *loadGameTableNavController;
    float IOS_VERSION;
}

/*! Interface builder properties and methods */
- (IBAction)showLoadGameView:(id)sender;
- (IBAction)saveCurrentGame:(id)sender;
- (IBAction)clearAllFrames:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loadBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearBarButton;
@end
