//
//  TDLMViewController.h
//  To Do List Manager
//
//  Created by Gerald Blake on 11/14/13.
//  Copyright (c) 2013 GB Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TDLMViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *taskObjects;
@property (nonatomic) BOOL hasHandleViewLoad;
- (NSString *)escape:(NSString *)text;
-(void) updateDatabase:(NSString*) query;
-(void) loadDatabaseIntoDataSource;
  
@end
