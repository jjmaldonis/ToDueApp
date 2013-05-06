//
//  TaskDetailViewController.h
//  toDueApp
//
//  Created by JASON MALDONIS on 2/7/13.
//  Copyright (c) 2013 Coe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface TaskDetailViewController : UITableViewController

@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;

@end
