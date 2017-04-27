//
//  FrameSelectionView.m
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/17/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import "FrameSelectionView.h"

@interface FrameSelectionView ()

@end

@implementation FrameSelectionView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

//Determine appropriate score value based on button tapped, and send result to delegate
- (IBAction)selectValue:(id)sender
{
    NSString *value=@"";
    switch ([sender tag])
    {
        case 0:
            value=@"1";
            break;
        case 1:
            value=@"2";
            break;
        case 2:
            value=@"3";
            break;
        case 3:
            value=@"4";
            break;
        case 4:
            value=@"5";
            break;
        case 5:
            value=@"6";
            break;
        case 6:
            value=@"7";
            break;
        case 7:
            value=@"8";
            break;
        case 8:
            value=@"9";
            break;
        case 9:
            value=@"/";
            break;
        case 10:
            value=@"X";
            break;
        case 11:
            value=@"0";
            break;
    }
    [self.delegate didSelectItemWithValue:value];
}

//Set valid inputs
- (void)setInputs:(NSArray *)validInputs
{
    for (int i=0; i<[self.view subviews].count; i++)
    {
        UIButton *btn = (UIButton *)[[self.view subviews] objectAtIndex:i];
        [btn setEnabled:NO];
    }
    UIButton *btn;
    for (NSString *s in validInputs)
    {
        if ([s isEqualToString:@"0"])
        {
            btn = (UIButton *)[self.view viewWithTag:11];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"1"])
        {
            btn = (UIButton *)[self.view viewWithTag:0];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"2"])
        {
            btn = (UIButton *)[self.view viewWithTag:1];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"3"])
        {
            btn = (UIButton *)[self.view viewWithTag:2];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"4"])
        {
            btn = (UIButton *)[self.view viewWithTag:3];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"5"])
        {
            btn = (UIButton *)[self.view viewWithTag:4];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"6"])
        {
            btn = (UIButton *)[self.view viewWithTag:5];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"7"])
        {
            btn = (UIButton *)[self.view viewWithTag:6];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"8"])
        {
            btn = (UIButton *)[self.view viewWithTag:7];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"9"])
        {
            btn = (UIButton *)[self.view viewWithTag:8];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"X"])
        {
            btn = (UIButton *)[self.view viewWithTag:10];
            [btn setEnabled:YES];
        }
        else if ([s isEqualToString:@"/"])
        {
            btn = (UIButton *)[self.view viewWithTag:9];
            [btn setEnabled:YES];
        }
    }
}
@end
