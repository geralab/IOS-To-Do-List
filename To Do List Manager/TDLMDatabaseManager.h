//
//  TDLMDatabaseManager.h
//  To Do List Manager
//
//  Created by Gerald Blake on 11/16/13.
//  Copyright (c) 2013 GB Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TDLMViewController.h"


@interface TDLMDatabaseManager : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UITextField *subTitleTextBox;
@property (strong, nonatomic) IBOutlet UITextField *titleTextBox;
@property (nonatomic,strong) Task *theTask;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (NSString *)escape:(NSString *)text;
-(void) updateDatabase:(NSString*) query;


@end
