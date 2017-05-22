//
//  Repo.m
//  Github Repos
//
//  Created by Marc Maguire on 2017-05-22.
//  Copyright © 2017 Marc Maguire. All rights reserved.
//

#import "Repo.h"

@implementation Repo

- (instancetype)initWithName:(NSString *)name{
    
    if (self = [super init]){
        
        _name = name;
    }
    
    return self;
}

@end
