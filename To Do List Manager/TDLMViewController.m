//
//  TDLMViewController.m
//  To Do List Manager
//
//  Created by Gerald Blake on 11/14/13.
//  Copyright (c) 2013 GB Enterprises. All rights reserved.
//

#import "TDLMViewController.h"
#import "Task.h"

@interface TDLMViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *printOut;

@end

@implementation TDLMViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDatabaseIntoDataSource];
        [self.tableView reloadData];
    });
            
    
    
    
    /////////////////////////////////////////
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)RefreshView:(UIBarButtonItem *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDatabaseIntoDataSource];
        [self.tableView reloadData];
    });
    
}

-(void) loadDatabaseIntoDataSource{
    self.taskObjects = [[NSMutableArray alloc]init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.cs.okstate.edu/~geralab/outputSQL.php"]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSMutableArray *myArray = [NSJSONSerialization JSONObjectWithData:response
                                                              options:NSJSONReadingMutableContainers error:&jsonParsingError];
    for (int i = 0; i < [myArray count]; i++) {
        NSLog(@"%@",myArray[i]);
    }
    NSDictionary *theDictionary = [[NSDictionary alloc]init];
    
    for(int i=0; i<[myArray count];i++)
    {
        Task* task = [[Task alloc]init];
        [task initialize];
        theDictionary= [myArray objectAtIndex:i];
        
        task.title = (NSString*)[theDictionary objectForKey:@"TITLE"];
        task.subTitle = (NSString*)[theDictionary objectForKey:@"SUBTITLE"];
        task.highPriority = [[theDictionary objectForKey:@"HIGH"]integerValue];
        task.completed = [[theDictionary objectForKey:@"COMPLETED"] integerValue];
        
        
        [self.taskObjects addObject:task];
        
    }

}
-(void) updateDatabase:(NSString*) query{
    NSString * baseUrl= @"http://www.cs.okstate.edu/~geralab/didSelectUpdate.php?query=";
    NSString * urlQuery = [self escape:query];
    baseUrl = [baseUrl stringByAppendingString:urlQuery];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseUrl]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
       
    [self loadDatabaseIntoDataSource];
    
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self updateDatabase:@"DELETE FROM geralab_todo_tasks WHERE COMPLETED = 1"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });


}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    // Return the number of rows in the section.
    return self.taskObjects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taskObject";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = ((Task*)(self.taskObjects[indexPath.row])).title;
    cell.detailTextLabel.text = ((Task*)(self.taskObjects[indexPath.row])).subTitle;
   
    if(((Task*)self.taskObjects[indexPath.row]).completed)
    {

        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ironman_head"]];
    }
    else
    {
        
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck"]];
        
    }
    
    if(((Task*)self.taskObjects[indexPath.row]).highPriority)
    {
        [cell setBackgroundColor: [UIColor redColor]];
    }else
    {
         [cell setBackgroundColor: [UIColor whiteColor]];
    }
    

    // Configure the cell...
    self.printOut.title = @"";
    return cell;
}
-(BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((Task*)self.taskObjects[indexPath.row]).completed = !((Task*)self.taskObjects[indexPath.row]).completed;
    Task *task = self.taskObjects[indexPath.row];
    int completed = ((Task*)self.taskObjects[indexPath.row]).completed;

    
    
    
        [self updateDatabase:[NSString stringWithFormat: @"UPDATE geralab_todo_tasks SET COMPLETED = %u WHERE TITLE = (\"%@\") AND SUBTITLE = (\"%@\")",completed,
                              task.title,task.subTitle]];
   
    
    
    [tableView reloadData];
}
- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        
        Task* task = (Task*)self.taskObjects[indexPath.row];
    [self updateDatabase:[NSString stringWithFormat:
                                  @"DELETE FROM geralab_todo_tasks WHERE TITLE = (\"%@\") AND SUBTITLE = (\"%@\")",
                                  task.title,task.subTitle]];
            
        
        // Delete the row from the data source
        
        //[self.taskObjects removeObjectAtIndex:indexPath.row];
        [self loadDatabaseIntoDataSource];
        [tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



- (void)viewWillAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDatabaseIntoDataSource];
        [self.tableView reloadData];
    });
    [super viewWillAppear:animated];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDatabaseIntoDataSource];
        [self.tableView reloadData];
    });
    
   // Task* theTask = ((TDLMDatabaseManager*)segue.destinationViewController).theTask;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   // [self.taskObjects addObject:theTask];
}



@end
