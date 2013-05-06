//
//  Task.h
//  toDueApp
//
//  Created by JASON MALDONIS on 2/7/13.
//  Copyright (c) 2013 Coe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject <NSCoding>

@property (nonatomic/*, copy*/) NSString *taskName;
@property (nonatomic) BOOL *completed;
-(id)initWithName:(NSString *)taskName;

@end