//
//  SettingsViewController.h
//  Kiwi
//
//  Created by Francesca Nannizzi on 1/26/14.
//  Copyright (c) 2014 TeamCocoaPebbles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImage *logoImage;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UIView *logoView;
@property (strong, nonatomic) UITableView *tableView;

@end
