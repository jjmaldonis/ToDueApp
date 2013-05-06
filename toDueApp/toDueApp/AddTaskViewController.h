//
//  AddTaskViewController.h
//  toDueApp
//
//  Created by JASON MALDONIS on 2/7/13.
//  Copyright (c) 2013 Coe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

//@interface AddTaskViewController : UITableViewController

@interface AddTaskViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskInput;
@property (strong, nonatomic) Task *task;

@end
