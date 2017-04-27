//
//  LoadGameTable.h
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/19/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameManager.h"

/*! Object delegate */
@protocol LoadGameDelegate <NSObject>
@optional
-(void)loadGameWithName:(NSString *)name;
@end

@interface LoadGameTable : UITableViewController
{
    GameManager *gameMan;
    NSArray *savedGameNames;
    UIBarButtonItem *closeButton;
    UIBarButtonItem *editButton;
}

@property (nonatomic, strong) id <LoadGameDelegate> delegate;
-(id)init;

@end
