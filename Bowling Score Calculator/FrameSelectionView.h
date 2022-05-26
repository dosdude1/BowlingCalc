//
//  FrameSelectionView.h
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/17/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! Object delegate */
@protocol FrameSelectionDelegate <NSObject>
@optional
-(void)didSelectItemWithValue:(NSString *)value;
@end

@interface FrameSelectionView : UIViewController
@property (nonatomic, strong) id <FrameSelectionDelegate> delegate;


/*!
 Set the valid inputs of the view
 
 @param validInputs An array of strings containing the valid inputs
 */
- (void)setInputs:(NSArray *)validInputs;

@end
