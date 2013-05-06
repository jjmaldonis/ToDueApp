//
//  TaskMasterViewController.m
//  toDueApp
//
//  Created by JASON MALDONIS on 2/7/13.
//  Copyright (c) 2013 Coe. All rights reserved.
//

#import "TaskMasterViewController.h"

#import "TaskDetailViewController.h"

#import "Task.h"

#import "AddTaskViewController.h"

@class Task;

@interface TaskMasterViewController () {
    NSMutableArray *masterTaskList;
}
@end

@implementation TaskMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:app];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    if ([fileManager fileExistsAtPath:plistPath] == YES)
    {
        NSMutableArray *masterList = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        [self setMasterTaskList:masterList];
    }
    else
    {
        [self initializeDefaultDataList];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    for(NSUInteger j = 0 ; j < [masterTaskList count] ; j++){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
        
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
        Task *taskAtIndex = [masterTaskList objectAtIndex:indexPath.row];
        if(taskAtIndex.completed) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            taskAtIndex.completed = true;
            NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
            cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.textLabel.text attributes:attributes];
            cell.textLabel.textColor = [UIColor redColor];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            taskAtIndex.completed = false;
            cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.textLabel.text];
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    [NSKeyedArchiver archiveRootObject:masterTaskList toFile:plistPath];
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        
        AddTaskViewController *addController = [segue sourceViewController];
        if (addController.task) {
            Task *task = addController.task;
            [self addTask:task];
            
            [[self tableView] reloadData];
        }
        //[self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.textLabel.text];
        
        [self removeTask:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[self tableView] reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    for(NSUInteger j = 0 ; j < [masterTaskList count] ; j++){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
        
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
        Task *taskAtIndex = [masterTaskList objectAtIndex:indexPath.row];
        if(taskAtIndex.completed) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            taskAtIndex.completed = true;
            NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
            cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.textLabel.text attributes:attributes];
            cell.textLabel.textColor = [UIColor redColor];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            taskAtIndex.completed = false;
            cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.textLabel.text];
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [masterTaskList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    
    Task *taskAtIndex = [masterTaskList objectAtIndex:indexPath.row];
    cell.textLabel.text = taskAtIndex.taskName;
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowTaskDetails"]) {
        TaskDetailViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.task = [self objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Task *taskAtIndex = [masterTaskList objectAtIndex:indexPath.row];
    if(!taskAtIndex.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        taskAtIndex.completed = true;
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.textLabel.text attributes:attributes];
        cell.textLabel.textColor = [UIColor redColor];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        taskAtIndex.completed = false;
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cell.textLabel.text];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath
   {
   if (editingStyle == UITableViewCellEditingStyleDelete) {
   [masterTaskList removeObjectAtIndex:indexPath.row];
   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
   } else if (editingStyle == UITableViewCellEditingStyleInsert) {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
   }
}*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/



//__________________________________________________________________________________________

- (void)initializeDefaultDataList {
    NSMutableArray *taskList = [[NSMutableArray alloc] init];
    masterTaskList = taskList;
}

- (void)setMasterTaskList:(NSMutableArray *)newList {
    if (masterTaskList != newList) {
        masterTaskList = [newList mutableCopy];
    }
}

- (NSMutableArray*)getMasterTaskList {
    return masterTaskList;
}

- (NSUInteger)countOfList {
    //NSLog(@"%u",[masterTaskList count]);
    return [masterTaskList count];
}

- (Task *)objectInListAtIndex:(NSUInteger)theIndex {
    return [masterTaskList objectAtIndex:theIndex];
}

- (void)addTask:(Task *)task {
    [masterTaskList addObject:task];
}

- (void)removeTask:(NSUInteger)theIndex {
    [masterTaskList removeObjectAtIndex:theIndex];
}

@end
