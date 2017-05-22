//
//  Repo.h
//  Github Repos
//
//  Created by Marc Maguire on 2017-05-22.
//  Copyright © 2017 Marc Maguire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repo : NSObject

@property (nonatomic) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end
