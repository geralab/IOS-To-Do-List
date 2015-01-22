//
//  Task.h
//  To Do List Manager
//
//  Created by Gerald Blake on 11/14/13.
//  Copyright (c) 2013 GB Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* subTitle;
@property (nonatomic) int highPriority;
@property (nonatomic) int completed;


-(void) initialize;
@end
