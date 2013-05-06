//
//  TaskMasterViewController.h
//  toDueApp
//
//  Created by JASON MALDONIS on 2/7/13.
//  Copyright (c) 2013 Coe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@interface TaskMasterViewController : UITableViewController

//- (void)removeTask:(NSUInteger)theIndex;
- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

- (void)addTask:(Task *)task;
@end
