//
//  BowlingScoreTable.m
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/17/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import "BowlingScoreTable.h"

@interface BowlingScoreTable ()

@end

@implementation BowlingScoreTable

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

//Main view and application initialization
- (void)viewDidLoad
{
    [super viewDidLoad];
    prefs=[PreferencesHandler sharedInstance];
    //IOS_VERSION=[[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [self.navigationController.navigationBar standardAppearance];
        [appearance setBackgroundImage:[UIImage imageNamed:@"NavBar-Wood"]];
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [self.navigationController.navigationBar setStandardAppearance:appearance];
        [self.navigationController.navigationBar setCompactAppearance:appearance];
        [self.navigationController.navigationBar setScrollEdgeAppearance:appearance];
        [self.navigationController.navigationBar setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationItem setTitle:@"Bowling Score Calculator"];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"NavBar-Wood"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0) resizingMode:UIImageResizingModeStretch] forBarMetrics: UIBarMetricsDefault];
    
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_wood_texture"]];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    self.tableView.tableFooterView.backgroundColor=[UIColor clearColor];
    if (@available(iOS 15.0, *)) {
        [self.tableView setSectionHeaderTopPadding:0.0f];
    }
    
    [self setUpToolbar];
    
    if ([prefs shouldAutoReloadGame])
    {
        [self setupGameFromSaveWithName:@"currentGame"];
    }
    else
    {
        [self setupNewGame];
    }
}

//Generate the score button for each roll at each frame
-(void)generateButtons
{
    tableCells=[[NSMutableArray alloc] init];
    for (int i=0; i < 10; i++)
    {
        NSArray *buttonsArray;
        UIButton *score1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        score1Btn.frame = CGRectMake(60, 6, 43, 43);
        [score1Btn setTitle:[self getStringForValue:[game getValueForRoll:1 atFrame:i]] forState:UIControlStateNormal];
        score1Btn.titleLabel.font=[UIFont systemFontOfSize:25];
        [score1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [score1Btn setBackgroundColor:[UIColor whiteColor]];
        [score1Btn setTag:101];
        [score1Btn addTarget:self action:@selector(showFrameSelectionView:) forControlEvents:UIControlEventTouchUpInside];
        score1Btn.layer.cornerRadius = 3.0;
        score1Btn.layer.shadowColor = [UIColor blackColor].CGColor;
        score1Btn.layer.shadowOpacity = 1.0f;
        score1Btn.layer.shadowRadius = 5.5f;
        score1Btn.layer.shadowOffset=CGSizeZero;
        score1Btn.layer.masksToBounds=NO;
        score1Btn.layer.shouldRasterize=YES;
        score1Btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        UIButton *score2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        score2Btn.titleLabel.font=[UIFont systemFontOfSize:25];
        [score2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[[score2Btn layer] setBorderWidth:1.0f];
        [score2Btn setBackgroundColor:[UIColor whiteColor]];
        [score2Btn setTag:102];
        [score2Btn addTarget:self action:@selector(showFrameSelectionView:) forControlEvents:UIControlEventTouchUpInside];
        score2Btn.frame = CGRectMake(120, 6, 43, 43);
        [score2Btn setTitle:[self getStringForValue:[game getValueForRoll:2 atFrame:i]] forState:UIControlStateNormal];
        score2Btn.layer.cornerRadius = 3.0;
        score2Btn.layer.shadowColor = [UIColor blackColor].CGColor;
        score2Btn.layer.shadowOpacity = 1.0f;
        score2Btn.layer.shadowRadius = 5.5f;
        score2Btn.layer.shadowOffset=CGSizeZero;
        score2Btn.layer.masksToBounds=NO;
        score2Btn.layer.shouldRasterize=YES;
        score2Btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        
        UIButton *score3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        score3Btn.titleLabel.font=[UIFont systemFontOfSize:25];
        [score3Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[[score3Btn layer] setBorderWidth:1.0f];
        [score3Btn setBackgroundColor:[UIColor whiteColor]];
        [score3Btn setTag:103];
        [score3Btn addTarget:self action:@selector(showFrameSelectionView:) forControlEvents:UIControlEventTouchUpInside];
        score3Btn.frame = CGRectMake(180, 6, 43, 43);
        [score3Btn setTitle:[self getStringForValue:[game getValueForRoll:3 atFrame:i]] forState:UIControlStateNormal];
        score3Btn.layer.cornerRadius = 3.0;
        score3Btn.layer.shadowColor = [UIColor blackColor].CGColor;
        score3Btn.layer.shadowOpacity = 1.0f;
        score3Btn.layer.shadowRadius = 5.5;
        score3Btn.layer.shadowOffset=CGSizeZero;
        score3Btn.layer.masksToBounds=NO;
        score3Btn.layer.shouldRasterize=YES;
        score3Btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        if (i == 9)
        {
            buttonsArray=[NSArray arrayWithObjects:score1Btn, score2Btn, score3Btn, nil];
        }
        else
        {
            buttonsArray=[NSArray arrayWithObjects:score1Btn, score2Btn, nil];
        }
        [tableCells addObject:buttonsArray];
    }
}

//Set up the bottom toolbar
-(void)setUpToolbar
{
    
    if (@available(iOS 15.0, *)) {
        UIToolbarAppearance *appearance = [self.navigationController.toolbar standardAppearance];
        [appearance setBackgroundImage:[UIImage imageNamed:@"NavBar-Wood"]];
        [self.navigationController.toolbar setStandardAppearance:appearance];
        [self.navigationController.toolbar setCompactAppearance:appearance];
        [self.navigationController.toolbar setScrollEdgeAppearance:appearance];
    }
    
    self.navigationController.toolbarHidden=NO;
    [self.navigationController.toolbar setTranslucent:NO];
    [self.navigationController.toolbar setBackgroundImage:[[UIImage imageNamed:@"NavBar-Wood"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0) resizingMode:UIImageResizingModeStretch] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    UIBarButtonItem *clearBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAllFrames)];
    [clearBarButton setBackgroundImage:[[UIImage imageNamed:@"button_texture"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [clearBarButton setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *loadBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStyleBordered target:self action:@selector(showLoadGameView)];
    [loadBarButton setBackgroundImage:[[UIImage imageNamed:@"button_texture"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [loadBarButton setTintColor:[UIColor whiteColor]];
    
    //UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //[spacer2 setWidth:15];
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveCurrentGame)];
    [saveBarButton setBackgroundImage:[[UIImage imageNamed:@"button_texture"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [saveBarButton setTintColor:[UIColor whiteColor]];
    
    [self setToolbarItems:[NSArray arrayWithObjects:clearBarButton, spacer, loadBarButton, saveBarButton, nil]];
}

//Return formatted score representation for use as the button text
-(NSString *)getStringForValue:(NSString *)value
{
    NSString *val=@"";
    if ([value isEqualToString:@"0"])
    {
        val=@"-";
    }
    else
    {
        val=value;
    }
    return val;
}

//Set up a new game
-(void)setupNewGame
{
    game=[[Game alloc]init];
    game.delegate=self;
    [self generateButtons];
}

//Set up a game from a save file
-(void)setupGameFromSaveWithName:(NSString *)saveName
{
    game = [[Game alloc] initWithSavedGame:saveName];
    game.delegate=self;
    [self generateButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [[cell.contentView viewWithTag:101] removeFromSuperview];
    [[cell.contentView viewWithTag:102] removeFromSuperview];
    [[cell.contentView viewWithTag:103] removeFromSuperview];
    for (int i=0; i<[[tableCells objectAtIndex:indexPath.section] count]; i++)
    {
        [cell.contentView addSubview:[[tableCells objectAtIndex:indexPath.section] objectAtIndex:i]];
    }
    
    cell.layer.cornerRadius=8;
    cell.clipsToBounds=YES;
    cell.textLabel.text=[NSString stringWithFormat:@"%ld", indexPath.section+1];
    [cell.textLabel setFont:[UIFont systemFontOfSize:21.0]];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%d", [game getRunningTotalForFrame:(int)indexPath.section]];
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:26.0]];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_wood_texture"]];
}

#pragma mark - Helper Methods
//Set up and/or show the frame selection view
- (void)showFrameSelectionView:(id)sender
{
    if (!frameSelectionView)
    {
        frameSelectionView=[[FrameSelectionView alloc] init];
        frameSelectionView.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popview_wood_texture"]];
        frameSelectionView.delegate=self;
    }
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *tappedIP = [self.tableView indexPathForRowAtPoint:buttonPosition];
    selectedRow=tappedIP.section;
    selectedButton=[sender tag]-101;
    CGRect buttonRect=[[[self.tableView cellForRowAtIndexPath:tappedIP] contentView] viewWithTag:[sender tag]].frame;
    buttonRect.origin=buttonPosition;
    if (!popController)
    {
        UIViewController *containerVC = [[UIViewController alloc] init];
        [containerVC.view addSubview:frameSelectionView.view];
        [containerVC.view setFrame:frameSelectionView.view.frame];
        [containerVC addChildViewController:frameSelectionView];
        
        if (@available(iOS 13.0, *)) {
            UILayoutGuide* guide = containerVC.view.safeAreaLayoutGuide;
            frameSelectionView.view.translatesAutoresizingMaskIntoConstraints = NO;
            [frameSelectionView.view.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
            [frameSelectionView.view.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
            [frameSelectionView.view.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
            [frameSelectionView.view.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
            [containerVC.view layoutIfNeeded];
        }
        
        popController=[[UIPopoverController alloc] initWithContentViewController:containerVC];
        popController.popoverContentSize=CGSizeMake(frameSelectionView.view.frame.size.width, frameSelectionView.view.frame.size.height);
        popController.delegate=self;
        if (@available(iOS 7.0, *))
        {
            popController.backgroundColor=[UIColor colorWithRed:194.0/255.0 green:128.0/255.0 blue:70.0/255.0 alpha:1.0];
        }
        
    }
    [frameSelectionView setInputs:[game getValidInputsForRoll:selectedButton+1 atFrame:selectedRow]];
    [self setViewAlpha:0.6f withAnimationDuration:0.07];
    [popController presentPopoverFromRect:buttonRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown | UIPopoverArrowDirectionUp animated:YES];
    if (@available(iOS 7.0, *))
    {
        if ([popController popoverArrowDirection] == UIPopoverArrowDirectionUp)
        {
            popController.backgroundColor=[UIColor colorWithRed:194.0/255.0 green:128.0/255.0 blue:70.0/255.0 alpha:1.0];
        }
        else
        {
            popController.backgroundColor=[UIColor colorWithRed:171.0/255.0 green:111.0/255.0 blue:57.0/255.0 alpha:1.0];
        }
    }
}

//Delegated method, called when a button is tapped in frame selection view
-(void)didSelectItemWithValue:(NSString *)value
{
    if (![prefs shouldAutoReloadGame])
    {
        [prefs setShouldAutoReloadGame:YES];
    }
    [game setValue:value forRoll:selectedButton+1 atFrame:selectedRow];
    UITableViewCell *selectedCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:selectedRow]];
    UIButton *b = (UIButton *)[[selectedCell contentView] viewWithTag:selectedButton+101];
    [b setTitle:[self getStringForValue:value] forState:UIControlStateNormal];
    [popController dismissPopoverAnimated:YES];
    [self setViewAlpha:1.0f withAnimationDuration:0.5];
    for (int i=0; i<[self.tableView numberOfSections]; i++)
    {
        UITableViewCell *c = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        c.detailTextLabel.text=[NSString stringWithFormat:@"%d", [game getRunningTotalForFrame:i]];
    }
    [game saveGameWithName:@"currentGame"];
}

//Set the view alpha to a value with a desired animation duration
-(void)setViewAlpha:(CGFloat)alpha withAnimationDuration:(double)duration
{
    [UIView animateWithDuration:duration animations:^{
        [self.view setAlpha:alpha];
    }];
}

//Delegated method, called when frame selection view is dismissed
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    [self setViewAlpha:1.0f withAnimationDuration:0.5];
    return YES;
}

//Delegated method, called when a value changes at a specific roll in a specific frame
-(void)valueDidChangeAtFrame:(int)frame forRoll:(int)roll toValue:(NSString *)value
{
    UITableViewCell *c = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:frame]];
    UIButton *b = (UIButton *)[[c contentView] viewWithTag:roll+101];
    [b setTitle:[self getStringForValue:value] forState:UIControlStateNormal];
}

//Initialize and/or show the load game view
- (void)showLoadGameView
{
    if (!loadGameTable)
    {
        loadGameTable = [[LoadGameTable alloc] init];
        loadGameTable.delegate=self;
        loadGameTableNavController = [[UINavigationController alloc] initWithRootViewController:loadGameTable];
        loadGameTableNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *appearance = [loadGameTableNavController.navigationBar standardAppearance];
            [appearance setBackgroundImage:[UIImage imageNamed:@"NavBar-Wood"]];
            [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            [loadGameTableNavController.navigationBar setStandardAppearance:appearance];
            [loadGameTableNavController.navigationBar setCompactAppearance:appearance];
            [loadGameTableNavController.navigationBar setScrollEdgeAppearance:appearance];
        }
        
        [loadGameTableNavController.navigationBar setBarStyle:UIBarStyleBlack];
        [loadGameTableNavController.navigationBar setTranslucent:NO];
        [loadGameTableNavController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"NavBar-Wood"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0) resizingMode:UIImageResizingModeStretch] forBarMetrics: UIBarMetricsDefault];
        
    }
    [self presentViewController:loadGameTableNavController animated:YES completion:nil];
}

//Show dialog for saving the current game
- (void)saveCurrentGame
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Game" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [alert setTag:100];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    [[alert textFieldAtIndex:0] setPlaceholder:@"Enter Save Name"];
    [alert show];
}

//Alert View delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            NSString *enteredName=[[alertView textFieldAtIndex:0] text];
            if ([enteredName isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Entry" message:@"Please enter a save name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if ([enteredName rangeOfString:@"/"].location != NSNotFound)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Save names cannot contain a \"/\"." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                [game saveGameWithName:enteredName];
            }
        }
    }
}

//Clears the game
- (void)clearAllFrames
{
    [prefs setShouldAutoReloadGame:NO];
    [game initEmptyGame];
    [self generateButtons];
    [self.tableView reloadData];
}

//Delegated method, called when a game is selected from the load game view
-(void)loadGameWithName:(NSString *)name
{
    [self setupGameFromSaveWithName:name];
    [self.tableView reloadData];
}
@end
