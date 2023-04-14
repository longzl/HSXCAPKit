//
//  CAPContainerOption.h
//  CAPKit
//
//  Created by Sam Chang on 29/09/2016.
//  Copyright © 2016 CAP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPContainerOption : NSObject

@property (nonatomic, strong) NSString *packagePath;

@property (nonatomic, strong) NSString *documentRoot;
@property (nonatomic, strong) NSString *appsRoot;
@property (nonatomic, strong) NSString *cacheRoot;

@property (nonatomic, strong) NSDictionary *environment;

@end
