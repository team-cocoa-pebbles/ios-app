//
//  SettingsViewController.m
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/26/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    self.logoView.backgroundColor = [UIColor orangeColor];
    
    //[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height
    self.logoImage = [UIImage imageWithContentsOfFile:@"kiwi_logo_shrunk.png"];
    self.logoImageView = [[UIImageView alloc] initWithImage:self.logoImage];
    self.logoImageView.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 100);
    [self.logoView addSubview:self.logoImageView];
    [self.view addSubview:self.logoView];
    
    // Set up poll table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height-180))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// HACK - instead of figuring out how to indent the headings properly, I just added a space to the front of the title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" Topics";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"OptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Only create the date formatter once
    UISwitch *toggleSwitch = [[UISwitch alloc] init];
    
    switch (indexPath.row) {
        case 0:
            [[cell textLabel] setText:@"Weather"];
            // Add toggle switch to polls the user did not create
            cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
            [cell.accessoryView addSubview:toggleSwitch];
            break;
            
        case 1:
            [[cell textLabel] setText:@"Traffic"];
            // Add toggle switch to polls the user did not create
            cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
            [cell.accessoryView addSubview:toggleSwitch];
            break;
        
        case 2:
            [[cell textLabel] setText:@"Facts"];
            // Add toggle switch to polls the user did not create
            cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
            [cell.accessoryView addSubview:toggleSwitch];
            break;
        
        case 3:
            [[cell textLabel] setText:@"Calendar"];
            // Add toggle switch to polls the user did not create
            cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
            [cell.accessoryView addSubview:toggleSwitch];
            break;
            
        case 4:
            [[cell textLabel] setText:@"Lunch"];
            // Add toggle switch to polls the user did not create
            cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
            [cell.accessoryView addSubview:toggleSwitch];
            break;
            
        case 5:
            [[cell textLabel] setText:@"Quotes"];
            // Add toggle switch to polls the user did not create
            cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
            [cell.accessoryView addSubview:toggleSwitch];
            break;
            
    }
    //cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row %d in section %d.", indexPath.row, indexPath.section);
    Poll *pollAtIndex;
    switch (indexPath.section) {
        case 0:
            pollAtIndex = [self.dataController objectInListAtIndex:(indexPath.row)];
            break;
            
        case 1:
            pollAtIndex = [self.dataController objectInCreatedListAtIndex:(indexPath.row)];
            break;
            
        default:
            NSLog(@"Something went wrong!");
            return;
    }
    
    NSLog(@"Selected poll: %@.", pollAtIndex.title);
    
    [self.pollTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PollDetailViewController *detailViewController = [[PollDetailViewController alloc] init];
    [detailViewController setPollDetails:pollAtIndex];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.navigationController pushViewController:detailViewController animated:YES];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
