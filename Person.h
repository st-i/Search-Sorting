//
//  Person.h
//  TableViewSearch
//
//  Created by iStef on 30.07.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;

@property (strong, nonatomic) NSDate *dateOfBirth;

+(NSDate *)randomDate;
+(Person *)randomPerson;

@end
