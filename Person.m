//
//  Person.m
//  TableViewSearch
//
//  Created by iStef on 30.07.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Person.h"

static NSString* firstNames[] = {
    
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

static int namesCount = 50;

@implementation Person

+(Person *)randomPerson
{
    Person *somePerson = [[Person alloc]init];
    
    somePerson.firstName = firstNames[arc4random() % namesCount];
    somePerson.lastName = lastNames[arc4random() % namesCount];
    somePerson.fullName = [NSString stringWithFormat:@"%@ %@", somePerson.firstName, somePerson.lastName];
    
    //NSLog(@"%@", somePerson.fullName);
    
    somePerson.dateOfBirth = [self randomDate];
    
    return somePerson;
}

+(NSDate *)randomDate
{
    NSInteger month = (arc4random() % 12) + 1;
    NSInteger day;
    NSInteger year = (arc4random() % 32) + 1967;
    
    switch (month) {
        /*case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            break;*/
        case 2:
            day = (arc4random() % 27) + 1;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day = (arc4random() % 30) + 1;
            break;
        default:
            day = (arc4random() % 31) + 1;
            break;
    }
    
    NSString *stringDate = [NSString stringWithFormat:@"%li/%li/%li", (long)day, (long)month, (long)year];
    
    //NSLog(@"%@", stringDate);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *date = [dateFormatter dateFromString:stringDate];
    
    return date;
}

@end
