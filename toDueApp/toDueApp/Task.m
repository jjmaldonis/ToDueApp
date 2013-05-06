//
//  Task.m
//  toDueApp
//
//  Created by JASON MALDONIS on 2/7/13.
//  Copyright (c) 2013 Coe. All rights reserved.
//

#import "Task.h"

@implementation Task

-(id)initWithName:(NSString *)taskName
{
    self = [super init];
    if (self) {
        
        self.taskName = [[NSString alloc] initWithString:taskName];
        self.completed = FALSE;
        
        return self;
    }
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.taskName forKey:@"taskName"];
    [aCoder encodeBool:self.completed forKey:@"completed"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        [self setTaskName:[aDecoder decodeObjectForKey:@"taskName"]];
        [self setCompleted:[aDecoder decodeBoolForKey:@"completed"]];

    }
    return self;
}

@end
