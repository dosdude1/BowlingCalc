//
//  Game.m
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/18/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import "Game.h"

@implementation Game

-(id)init
{
    self=[super init];
    if (self)
    {
        [self initEmptyGame];
    }
    return self;
}
-(instancetype)initWithSavedGame:(NSString *)gameName
{
    self = [super init];
    if (self)
    {
        [self loadGameWithName:gameName];
    }
    return self;
}
-(void)initEmptyGame
{
    isSavedGame=NO;
    frames=[[NSMutableArray alloc]init];
    for (int i=0; i<10; i++)
    {
        [frames addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"0", @"0", @"0", @"0", [NSNumber numberWithInt:0], nil] forKeys:[NSArray arrayWithObjects:@"roll1", @"roll2", @"roll3", @"score", @"runningTotal", nil]]];
    }
}
-(void)loadGameWithName:(NSString *)gameName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [[paths.firstObject stringByAppendingPathComponent:@"Games"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", gameName]];
    frames=[NSMutableArray arrayWithArray:[[NSArray alloc] initWithContentsOfFile:plistPath]];
}
-(void)saveGameWithName:(NSString *)saveName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[paths.firstObject stringByAppendingPathComponent:@"Games"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[paths.firstObject stringByAppendingPathComponent:@"Games"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [[paths.firstObject stringByAppendingPathComponent:@"Games"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", saveName]];
    [frames writeToFile:plistPath atomically:YES];
}
-(NSString *)getValueForRoll:(int)rollNum atFrame:(int)frameNum
{
    NSString *rollID=@"";
    switch (rollNum)
    {
        case 1:
            rollID=@"roll1";
            break;
        case 2:
            rollID=@"roll2";
            break;
        case 3:
            rollID=@"roll3";
            break;
    }
    return [[frames objectAtIndex:frameNum] objectForKey:rollID];
}
-(void)setValue:(NSString *)value forRoll:(int)rollNum atFrame:(int)frameNum
{
    NSString *rollID=@"";
    switch (rollNum)
    {
        case 1:
            rollID=@"roll1";
            break;
        case 2:
            rollID=@"roll2";
            break;
        case 3:
            rollID=@"roll3";
            break;
    }
    [[frames objectAtIndex:frameNum] setObject:value forKey:rollID];
    if (frameNum < 9)
    {
        if ([[[frames objectAtIndex:frameNum] objectForKey:@"roll1"] isEqualToString:@"X"] && ![[[frames objectAtIndex:frameNum] objectForKey:@"roll2"] isEqualToString:@"0"])
        {
            [[frames objectAtIndex:frameNum] setObject:@"0" forKey:@"roll2"];
            [self.delegate valueDidChangeAtFrame:frameNum forRoll:1 toValue:@"0"];
        }
    }
    else if (frameNum == 9)
    {
        if (![[[frames objectAtIndex:frameNum] objectForKey:@"roll1"] isEqualToString:@"X"])
        {
            if (!([[[frames objectAtIndex:frameNum] objectForKey:@"roll2"] isEqualToString:@"X"] || [[[frames objectAtIndex:frameNum] objectForKey:@"roll2"] isEqualToString:@"/"]))
            {
                [[frames objectAtIndex:frameNum] setObject:@"0" forKey:@"roll3"];
                [self.delegate valueDidChangeAtFrame:frameNum forRoll:2 toValue:@"0"];
            }
        }
        if ([[[frames objectAtIndex:frameNum] objectForKey:@"roll1"] isEqualToString:@"X"])
        {
            if ([[[frames objectAtIndex:frameNum] objectForKey:@"roll2"] isEqualToString:@"/"])
            {
                [[frames objectAtIndex:frameNum] setObject:@"0" forKey:@"roll2"];
                [self.delegate valueDidChangeAtFrame:frameNum forRoll:1 toValue:@"0"];
                [[frames objectAtIndex:frameNum] setObject:@"0" forKey:@"roll3"];
                [self.delegate valueDidChangeAtFrame:frameNum forRoll:2 toValue:@"0"];
            }
            if ([[[frames objectAtIndex:frameNum] objectForKey:@"roll3"] isEqualToString:@"X"] && ![[[frames objectAtIndex:frameNum] objectForKey:@"roll2"] isEqualToString:@"X"])
            {
                [[frames objectAtIndex:frameNum] setObject:@"0" forKey:@"roll3"];
                [self.delegate valueDidChangeAtFrame:frameNum forRoll:2 toValue:@"0"];
            }
        }
        if ([[[frames objectAtIndex:frameNum] objectForKey:@"roll2"] isEqualToString:@"X"])
        {
            if ([[[frames objectAtIndex:frameNum] objectForKey:@"roll3"] isEqualToString:@"/"])
            {
                [[frames objectAtIndex:frameNum] setObject:@"0" forKey:@"roll3"];
                [self.delegate valueDidChangeAtFrame:frameNum forRoll:2 toValue:@"0"];
            }
            if ([[[frames objectAtIndex:frameNum] objectForKey:@"roll3"] isEqualToString:@"X"] && ![[[frames objectAtIndex:frameNum] objectForKey:@"roll1"] isEqualToString:@"X"])
            {
                [[frames objectAtIndex:frameNum] setObject:@"0" forKey:@"roll2"];
                [self.delegate valueDidChangeAtFrame:frameNum forRoll:1 toValue:@"0"];
                [[frames objectAtIndex:frameNum] setObject:@"0" forKey:@"roll3"];
                [self.delegate valueDidChangeAtFrame:frameNum forRoll:2 toValue:@"0"];
            }
        }
        
    }
    for (int i=frames.count-1; i>=0; i--)
    {
        int frameScore=[self calculateScoreForFrame:i];
        [[frames objectAtIndex:i] setObject:[NSString stringWithFormat:@"%d", frameScore] forKey:@"score"];
    }
    int totalScore=0;
    for (int i=0; i<frames.count; i++)
    {
        totalScore+=[[[frames objectAtIndex:i]objectForKey:@"score"] intValue];
        [[frames objectAtIndex:i] setObject:[NSNumber numberWithInt:totalScore] forKey:@"runningTotal"];
    }
}

-(int)calculateScoreForFrame:(int)frame
{
    int score=0;
    NSDictionary *dict=[frames objectAtIndex:frame];
    NSString *roll1=[dict objectForKey:@"roll1"];
    NSString *roll2=[dict objectForKey:@"roll2"];
    NSString *roll3=[dict objectForKey:@"roll3"];
    if ([roll1 isEqualToString:@"X"])
    {
        if (frame < 8)
        {
            NSString *nextRoll1=[[frames objectAtIndex:frame+1] objectForKey:@"roll1"];
            NSString *nextRoll2=[[frames objectAtIndex:frame+1] objectForKey:@"roll2"];
            NSString *nextNextRoll1=[[frames objectAtIndex:frame+2] objectForKey:@"roll1"];
            if ([nextRoll1 isEqualToString:@"X"] && ![nextNextRoll1 isEqualToString:@"X"])
            {
                score = 20+[nextNextRoll1 intValue];
            }
            else if ([nextRoll1 isEqualToString:@"X"] && [nextNextRoll1 isEqualToString:@"X"])
            {
                score = 30;
            }
            else
            {
                if ([nextRoll2 isEqualToString:@"/"])
                {
                    score = 20;
                }
                else
                {
                    score = 10 + [nextRoll1 intValue] + [nextRoll2 intValue];
                }
            }
        }
        else if (frame == 8)
        {
            NSString *nextRoll1=[[frames objectAtIndex:frame+1] objectForKey:@"roll1"];
            NSString *nextRoll2=[[frames objectAtIndex:frame+1] objectForKey:@"roll2"];
            if ([nextRoll1 isEqualToString:@"X"])
            {
                if (![nextRoll2 isEqualToString:@"X"])
                {
                    score = 20 + [nextRoll2 intValue];
                }
                else
                {
                    score = 30;
                }
            }
            else if (![nextRoll1 isEqualToString:@"X"] && [nextRoll2 isEqualToString:@"/"])
            {
                score = 20;
            }
            else
            {
                score = 10 + [self getScoreForFrame:frame + 1];
            }
        }
        else if (frame == 9)
        {
            score = 10;
            if ([roll2 isEqualToString:@"X"])
            {
                if ([roll3 isEqualToString:@"X"])
                {
                    score += 20;
                }
                else
                {
                    score += 10 + [roll3 intValue];
                }
            }
            else if (![roll2 isEqualToString:@"X"])
            {
                if ([roll3 isEqualToString:@"/"])
                {
                    score += 10;
                }
                else
                {
                    score += [roll2 intValue] + [roll3 intValue];
                }
            }
            else
            {
                score += [roll2 intValue] + [roll3 intValue];
            }
        }
    }
    else if ([roll2 isEqualToString:@"/"])
    {
        if (frame < 9)
        {
            NSString *nextRoll1=[[frames objectAtIndex:frame+1] objectForKey:@"roll1"];
            if ([nextRoll1 isEqualToString:@"X"])
            {
                score = 20;
            }
            else
            {
                score = 10 + [nextRoll1 intValue];
            }
        }
        else if (frame == 9)
        {
            if ([roll3 isEqualToString:@"X"])
            {
                score = 20;
            }
            else
            {
                score = 10 + [roll3 intValue];
            }
        }
    }
    else
    {
        score += [roll1 intValue] + [roll2 intValue];
    }
    return score;
}
-(int)getScoreForFrame:(int)frame
{
    return [[[frames objectAtIndex:frame]objectForKey:@"score"] intValue];
}
-(int)getRunningTotalForFrame:(int)frame
{
    return [[[frames objectAtIndex:frame] objectForKey:@"runningTotal"] intValue];
}
-(NSArray *)getValidInputsForRoll:(int)roll atFrame:(int)frame
{
    NSArray *inputs = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *validInputs = [[NSMutableArray alloc]init];
    if (frame < 9)
    {
        if (roll == 2)
        {
            for (int i=0; i<inputs.count; i++)
            {
                if ([[[frames objectAtIndex:frame] objectForKey:@"roll1"] intValue] + [[inputs objectAtIndex:i] intValue] < 10 && ![[[frames objectAtIndex:frame] objectForKey:@"roll1"] isEqualToString:@"X"])
                {
                    [validInputs addObject:[inputs objectAtIndex:i]];
                }
            }
            if (![[[frames objectAtIndex:frame] objectForKey:@"roll1"] isEqualToString:@"X"])
            {
                [validInputs addObject:@"/"];
            }
        }
        else if (roll == 1)
        {
            [validInputs addObject:@"X"];
            for (int i=0; i<inputs.count; i++)
            {
                if ([[[frames objectAtIndex:frame] objectForKey:@"roll2"] intValue] + [[inputs objectAtIndex:i] intValue] < 10)
                {
                    [validInputs addObject:[inputs objectAtIndex:i]];
                }
            }
        }
    }
    else if (frame == 9)
    {
        if (roll == 1)
        {
            for (int i=0; i<inputs.count; i++)
            {
                if ([[[frames objectAtIndex:frame] objectForKey:@"roll2"] intValue] + [[inputs objectAtIndex:i] intValue] < 10)
                {
                    [validInputs addObject:[inputs objectAtIndex:i]];
                }
            }
            [validInputs addObject:@"X"];
        }
        else if (roll == 2)
        {
            for (int i=0; i<inputs.count; i++)
            {
                if (![[[frames objectAtIndex:frame] objectForKey:@"roll1"] isEqualToString:@"X"])
                {
                    if ([[[frames objectAtIndex:frame] objectForKey:@"roll1"] intValue] + [[inputs objectAtIndex:i] intValue] < 10)
                    {
                        [validInputs addObject:[inputs objectAtIndex:i]];
                    }
                }
                else
                {
                    if ([[[frames objectAtIndex:frame] objectForKey:@"roll3"] intValue] + [[inputs objectAtIndex:i] intValue] < 10)
                    {
                        [validInputs addObject:[inputs objectAtIndex:i]];
                    }
                }
            }
            if (![[[frames objectAtIndex:frame] objectForKey:@"roll1"] isEqualToString:@"X"])
            {
                [validInputs addObject:@"/"];
            }
            if ([[[frames objectAtIndex:frame] objectForKey:@"roll1"] isEqualToString:@"X"])
            {
                [validInputs addObject:@"X"];
            }
        }
        else if (roll == 3)
        {
            for (int i=0; i<inputs.count; i++)
            {
                if ([[[frames objectAtIndex:frame] objectForKey:@"roll2"] isEqualToString:@"X"] || [[[frames objectAtIndex:frame] objectForKey:@"roll2"] isEqualToString:@"/"] || [[[frames objectAtIndex:frame] objectForKey:@"roll1"] isEqualToString:@"X"])
                {
                    if ([[[frames objectAtIndex:frame] objectForKey:@"roll2"] intValue] + [[inputs objectAtIndex:i] intValue] < 10)
                    {
                        [validInputs addObject:[inputs objectAtIndex:i]];
                    }
                }
            }
            if ([[[frames objectAtIndex:frame] objectForKey:@"roll2"] isEqualToString:@"X"] || [[[frames objectAtIndex:frame] objectForKey:@"roll2"] isEqualToString:@"/"])
            {
                [validInputs addObject:@"X"];
            }
            if ([[[frames objectAtIndex:frame] objectForKey:@"roll1"] isEqualToString:@"X"] && ![[[frames objectAtIndex:frame] objectForKey:@"roll2"] isEqualToString:@"X"])
            {
                [validInputs addObject:@"/"];
            }
        }
    }
    return validInputs;
}
@end
