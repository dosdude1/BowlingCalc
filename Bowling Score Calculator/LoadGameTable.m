//
//  LoadGameTable.m
//  Bowling Score Calculator
//
//  Created by Collin Mistr on 3/19/17.
//  Copyright (c) 2017 dosdude1 Apps. All rights reserved.
//

#import "LoadGameTable.h"

@interface LoadGameTable ()

@end

@implementation LoadGameTable

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}
-(id)init
{
    self=[super init];
    if (self)
    {
        gameMan=[GameManager sharedInstance];
        savedGameNames=[gameMan getSavedGameNames];
    }
    return self;
}

//Initialize the view
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Load Game"];
    closeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Close"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(dismissModal:)];
    [closeButton setTintColor:[UIColor whiteColor]];
    [closeButton setBackgroundImage:[[UIImage imageNamed:@"button_texture"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem setRightBarButtonItem:closeButton];
    editButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Edit"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(toggleEditing:)];
    [editButton setTintColor:[UIColor whiteColor]];
    [editButton setBackgroundImage:[[UIImage imageNamed:@"button_texture"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:editButton];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"load_view_texture"]];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor brownColor];
}

//Delegated method, called when view is about to appear
-(void)viewWillAppear:(BOOL)animated
{
    savedGameNames=[gameMan getSavedGameNames];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (savedGameNames.count==0)
    {
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tableView.bounds.size.height/2, tableView.bounds.size.width, 25)];
        noDataLabel.text = @"No Saved Games";
        noDataLabel.font=[UIFont systemFontOfSize:25];
        noDataLabel.textColor = [UIColor whiteColor];
        noDataLabel.backgroundColor = [UIColor clearColor];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
        tableView.alwaysBounceVertical=NO;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.backgroundView=nil;
        tableView.alwaysBounceVertical=YES;
    }
    return [savedGameNames count];
}

- (void)dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[savedGameNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"Score: %d", [gameMan getScoreForGameWithName:[savedGameNames objectAtIndex:indexPath.row]]];
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.textColor=[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate loadGameWithName:[savedGameNames objectAtIndex:indexPath.row]];
    [self dismissModal:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [editButton setTitle:@"Done"];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [editButton setTitle:@"Edit"];
    [self.navigationItem setRightBarButtonItem:closeButton animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        [gameMan deleteSavedGameWithName:[savedGameNames objectAtIndex:indexPath.row]];
        savedGameNames = [gameMan getSavedGameNames];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_wood_texture"]];
}

//Toggle table editing
-(void)toggleEditing:(id)sender
{
    if ([self.tableView isEditing])
    {
        [self.tableView setEditing:NO animated:YES];
        [editButton setTitle:@"Edit"];
        [self.navigationItem setRightBarButtonItem:closeButton animated:YES];
    }
    else
    {
        [self.tableView setEditing:YES animated:YES];
        [editButton setTitle:@"Done"];
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}
@end
