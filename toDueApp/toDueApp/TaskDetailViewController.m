//
//  TaskDetailViewController.m
//  toDueApp
//
//  Created by JASON MALDONIS on 2/7/13.
//  Copyright (c) 2013 Coe. All rights reserved.
//

#import "TaskDetailViewController.h"

#import "Task.h"

@interface TaskDetailViewController ()
- (void)configureView;
@end

@implementation TaskDetailViewController

#pragma mark - Managing the detail item

- (void)setTask:(Task *) newTask
{
    if (_task != newTask) {
        _task = newTask;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    Task *theTask = self.task;
    
    if (theTask) {
        self.taskNameLabel.text = theTask.taskName;
    }
}

- (void)viewDidLoad //Do I put the viewDidLoad stuff from Notepad here as well? I put it in ViewController already
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
