//
//  TDLMDatabaseManager.m
//  To Do List Manager
//
//  Created by Gerald Blake on 11/16/13.
//  Copyright (c) 2013 GB Enterprises. All rights reserved.
//

#import "TDLMDatabaseManager.h"

@interface TDLMDatabaseManager ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *priorityType;

@end

@implementation TDLMDatabaseManager

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
	// Do any additional setup after loading the view.
    self.theTask = [[Task alloc]init];
    [self.theTask initialize];

      [self updateDatabase: @"CREATE TABLE IF NOT EXISTS geralab_todo_tasks (ID INTEGER PRIMARY KEY AUTO_INCREMENT, TITLE TEXT, SUBTITLE TEXT, HIGH INTEGER, COMPLETED INTEGER)"];
            
    
    
    

}

-(void) updateDatabase:(NSString*) query{
    NSString * baseUrl= @"http://www.cs.okstate.edu/~geralab/didSelectUpdate.php?query=";
    NSString * urlQuery = [self escape:query];
    baseUrl = [baseUrl stringByAppendingString:urlQuery];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseUrl]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
    
}
- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}
- (IBAction)PriorityTypeHandler:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0)
    {
        self.theTask.highPriority = NO;
    }else{
        self.theTask.highPriority =YES;
    }
}

- (IBAction)BackGroundExit:(UIControl *)sender {
    [self.titleTextBox resignFirstResponder];
    [self.subTitleTextBox resignFirstResponder];
}

- (IBAction)TitleTextBox:(UITextField *)sender {
    
    [sender resignFirstResponder];
}
- (IBAction)SubTitleTextBox:(UITextField *)sender {
    [sender resignFirstResponder];
}
- (IBAction)TextBoxValueChangeHandler:(UITextField *)sender {
    if([sender.text isEqual:@""])
    {
    
        [self.saveButton setEnabled:NO];
    }
    else
    {
        [self.saveButton setEnabled:YES];
        
    }
}


- (IBAction)Save:(UIButton *)sender {
 
    [self updateDatabase:[NSString stringWithFormat:
                               @"INSERT INTO geralab_todo_tasks (TITLE, SUBTITLE,HIGH,COMPLETED) VALUES (\"%@\", \"%@\",%u,%u)",
                               self.titleTextBox.text, self.subTitleTextBox.text,(int)self.theTask.highPriority,(int)self.theTask.completed]];
        
    
       
        self.theTask.title=self.titleTextBox.text;
        self.theTask.subTitle =self.subTitleTextBox.text;
    
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TDLMViewController* theDest = [segue destinationViewController];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [theDest loadDatabaseIntoDataSource];
        [theDest.tableView reloadData];
   });
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new
    //
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
