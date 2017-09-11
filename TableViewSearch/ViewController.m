//
//  ViewController.m
//  TableViewSearch
//
//  Created by iStef on 30.07.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

typedef enum
{
    SegmentIndexTypeBirthdaySort,
    SegmentIndexTypeFirstNameSort,
    SegmentIndexTypeLastNameSort
}SegmentIndexType;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *allUnsortedPersons;
@property (strong, nonatomic) NSMutableArray *personGroup;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableArray *personsSortedByMonth;
@property (strong, nonatomic) NSMutableArray *personsSortedByNameAndMonth;
@property (strong, nonatomic) NSArray *commonArray;
@property (strong, nonatomic) NSArray *searchingArray;

@property (assign, nonatomic) SegmentIndexType segmentIndex;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.searchBar.showsCancelButton = NO;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 100; i++)
    {
        Person *somePerson = [Person randomPerson];
        [array addObject:somePerson];
    }
    
    
    Person *Den = [[Person alloc] init];
    Den.firstName = @"Denis";
    Den.lastName = @"Stefanov";
    Den.fullName = [NSString stringWithFormat:@"%@ %@", Den.firstName, Den.lastName];
    
    NSString *stringDate = @"06/07/1985";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormatter dateFromString:stringDate];
    
    Den.dateOfBirth = date;
    
    [array addObject:Den];
    
    
    Person *mom = [[Person alloc] init];
    mom.firstName = @"Svetlana";
    mom.lastName = @"Stefanova";
    mom.fullName = [NSString stringWithFormat:@"%@ %@", mom.firstName, mom.lastName];
    
    NSString *stringDate1 = @"14/10/1964";
    NSDate *date1 = [dateFormatter dateFromString:stringDate1];
    
    mom.dateOfBirth = date1;
    
    [array addObject:mom];
    
    
    self.allUnsortedPersons = array;
    
    self.commonArray = [NSArray array];
    self.commonArray = [self sortByBirthday];
    //self.commonArray = [self sortByFirstName];
    //self.commonArray = [self sortByLastName];
    self.searchingArray = [NSArray arrayWithArray:self.commonArray];
    
    //[self sortByMonth];
    //[self sortByName];

    self.tableView.allowsSelection = NO;
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(IBAction)sortPersons:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == SegmentIndexTypeBirthdaySort)
    {
        self.commonArray = [self sortByBirthday];
        self.searchingArray = self.commonArray;
        
        self.segmentIndex = SegmentIndexTypeBirthdaySort;
        
    }else if (sender.selectedSegmentIndex == SegmentIndexTypeFirstNameSort) {
        self.commonArray = [self sortByFirstName];
        self.searchingArray = self.commonArray;
        self.segmentIndex = SegmentIndexTypeFirstNameSort;
        
    }else {
        self.commonArray = [self sortByLastName];
        self.searchingArray = self.commonArray;
        self.segmentIndex = SegmentIndexTypeLastNameSort;
    }
    
    self.searchBar.text = nil;
    [self.tableView reloadData];
}

#pragma mark - Sorting

-(NSArray *)sortByBirthday
{
    //self.allUnsortedPersons = [NSArray array];
    
    NSArray *personsSortedByBirthday = [NSArray array];
    
    personsSortedByBirthday = [self.allUnsortedPersons sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isKindOfClass:[Person class]] && [obj2 isKindOfClass:[Person class]]) {
            return [[(Person *)obj1 dateOfBirth] compare:[(Person *)obj2 dateOfBirth]];
        }
        return (NSComparisonResult)NSOrderedAscending;
    }];
    
    NSMutableArray *yearsOfBirth = [NSMutableArray array];
    NSInteger currentYearOfBirth = 0;
    
    for (Person *person in personsSortedByBirthday)
    {
        NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:person.dateOfBirth];
        NSInteger year = [dc year];
        NSMutableArray *newYearOfBirth = nil;
        
        if (currentYearOfBirth != year) {
            newYearOfBirth = [NSMutableArray array];
            //[newYearOfBirth addObject:person]; //#1 method
            [yearsOfBirth addObject:newYearOfBirth];
            currentYearOfBirth = year;
        }else{
            newYearOfBirth = [yearsOfBirth lastObject];
            //[newYearOfBirth addObject:person]; //#1 method
        }
        [newYearOfBirth addObject:person]; //#2 method
    }
    
    for (NSMutableArray *arrayOfPersons in yearsOfBirth)
    {
        [arrayOfPersons sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 isKindOfClass:[Person class]] && [obj2 isKindOfClass:[Person class]]) {
                if ([[(Person *)obj1 firstName] isEqualToString:[(Person *)obj2 firstName]]) {
                    return [[(Person *)obj1 lastName] compare:[(Person *)obj2 lastName]];
                }
                return [[(Person *)obj1 firstName] compare:[(Person *)obj2 firstName]];
            }
            return (NSComparisonResult)NSOrderedAscending;
        }];
    }
    return yearsOfBirth;
}

-(NSArray *)sortByFirstName
{
    NSArray *personsSortedByFirstName = [NSArray array];
    
    personsSortedByFirstName = [self.allUnsortedPersons sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isKindOfClass:[Person class]] && [obj2 isKindOfClass:[Person class]]) {
            if ([[(Person *)obj1 firstName] isEqualToString:[(Person *)obj2 firstName]]) {
                return [[(Person *)obj1 lastName] compare:[(Person *)obj2 lastName]];
            }
            return [[(Person *)obj1 firstName] compare:[(Person *)obj2 firstName]];
        }
        return (NSComparisonResult)NSOrderedAscending;
    }];

    NSMutableArray *namesOfPersons = [NSMutableArray array];
    NSString *currentFirstLetter = @"";

    for (Person *person in personsSortedByFirstName)
    {
        NSString *firstLetter = [person.firstName substringToIndex:1];
        NSMutableArray *newNameArray = nil;

        if (currentFirstLetter != firstLetter) {
            newNameArray = [NSMutableArray array];
            [namesOfPersons addObject:newNameArray];
            currentFirstLetter = firstLetter;
        }else{
            newNameArray = [namesOfPersons lastObject];
        }
        [newNameArray addObject:person];
    }
    return namesOfPersons;
}

-(NSArray *)sortByLastName
{
    NSArray *personsSortedByLastName = [NSArray array];
    
    personsSortedByLastName = [self.allUnsortedPersons sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isKindOfClass:[Person class]] && [obj2 isKindOfClass:[Person class]]) {
            if ([[(Person *)obj1 lastName] isEqualToString:[(Person *)obj2 lastName]]) {
                return [[(Person *)obj1 firstName] compare:[(Person *)obj2 firstName]];
            }
            return [[(Person *)obj1 lastName] compare:[(Person *)obj2 lastName]];
        }
        return (NSComparisonResult)NSOrderedAscending;
    }];
    
    NSMutableArray *namesOfPersons = [NSMutableArray array];
    NSString *currentFirstLetter = @"";
    
    for (Person *person in personsSortedByLastName)
    {
        NSString *firstLetter = [person.lastName substringToIndex:1];
        NSMutableArray *newNameArray = nil;
        
        if (currentFirstLetter != firstLetter) {
            newNameArray = [NSMutableArray array];
            [namesOfPersons addObject:newNameArray];
            currentFirstLetter = firstLetter;
        }else{
            newNameArray = [namesOfPersons lastObject];
        }
        [newNameArray addObject:person];
    }
    return namesOfPersons;
}


/*-(void)sortByMonth
{
    self.personsSortedByMonth = [NSMutableArray array];
    
    for (int i = 0; i<12; i++) {
        NSMutableArray *currentMonth = [[NSMutableArray alloc] init];
        [self.personsSortedByMonth addObject:currentMonth];
    }
    
    for (Person *person in self.allUnsortedPersons) {
        NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:person.dateOfBirth];
        NSInteger month = [dc month];
        //NSLog(@"%li", (long)month);
        NSMutableArray *array = [self.personsSortedByMonth objectAtIndex:month-1];
        [array addObject:person];
        self.personsSortedByMonth[month-1] = array;
    }
}*/

/*-(void)sortByName
{
    self.personsSortedByNameAndMonth = [NSMutableArray array];
    self.commonArray = [NSArray array];
    
    for (NSMutableArray *array in self.personsSortedByMonth) {
        //Sorting method #1
        NSArray *newArray = [NSArray array];
        
        newArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 isKindOfClass:[Person class]] && [obj2 isKindOfClass:[Person class]]) {
                if ([[(Person *)obj1 firstName] isEqualToString:[(Person *)obj2 firstName]]) {
                    return [[(Person *)obj1 lastName] compare:[(Person *)obj2 lastName]];
                }
                return [[(Person *)obj1 firstName] compare:[(Person *)obj2 firstName]];
            }
            return (NSComparisonResult)NSOrderedAscending;
        }];
        
        [self.personsSortedByNameAndMonth addObject:newArray];
        self.commonArray = self.personsSortedByNameAndMonth;
        
*/
        //Sorting method #2
        /*[array sortUsingComparator:^NSComparisonResult(Person *obj1, Person *obj2)
                    {
                        if ([[(Person *)obj1 firstName] isEqualToString:[(Person *)obj2 firstName]]) {
                            return [[(Person *)obj1 lastName] compare:[(Person *)obj2 lastName]];
                        }else{
                            return [[(Person *)obj1 firstName] compare:[(Person *)obj2 firstName]];
                        }
                        return (NSComparisonResult)NSOrderedAscending;
                    }];
        [self.personsSortedByNameAndMonth addObject:array];*/
   // }
//}

#pragma mark - Search

-(NSMutableArray *)createSectionWithSearchingFromArray:(NSArray *)array withFilter:(NSString *)filter
{
    NSMutableArray *sectionsArray = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        NSMutableArray *newArray = [array objectAtIndex:i];
        NSMutableArray *section = [NSMutableArray array];
        for (int j = 0; j < newArray.count; j++) {
            Person *person = [newArray objectAtIndex:j];
            NSString *personFullName = person.fullName;
            if (filter.length > 0 && [personFullName rangeOfString:filter options:NSCaseInsensitiveSearch].location == NSNotFound) {
                continue;
            }
            [section addObject:person];
        }
        if (section.count != 0) {
            [sectionsArray addObject:section];
        }
        section = nil;
    }
    return sectionsArray;
}

#pragma mark - UITableViewDataSource

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.segmentIndex == SegmentIndexTypeBirthdaySort) {
        NSMutableArray *titles = [NSMutableArray array];
        
        for (NSArray *array in self.searchingArray) {
            Person *person = array[0];
            NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:person.dateOfBirth];
            NSInteger year = [dc year];
            NSString *stringYear = [NSString stringWithFormat:@"%ld", (long)year];
            NSString *titleSign = [stringYear substringFromIndex:2];
            [titles addObject:titleSign];
        }
        return titles;
    }else if (self.segmentIndex == SegmentIndexTypeFirstNameSort) {
        NSMutableArray *titles = [NSMutableArray array];

        for (NSArray *array in self.searchingArray) {
            Person *person = array[0];
            [titles addObject:[person.firstName substringToIndex:1]];
        }
        return titles;
    }else{
        NSMutableArray *titles = [NSMutableArray array];
        
        for (NSArray *array in self.searchingArray) {
            Person *person = array[0];
            [titles addObject:[person.lastName substringToIndex:1]];
        }
        return titles;
    }
    
    /*NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 1; i<self.searchingArray.count+1; i++) {
        NSString *string = [NSString stringWithFormat:@"%d", i];
        [array addObject:string];
    }
    return array;*/
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = [self.searchingArray objectAtIndex:section];
    Person *person = [array objectAtIndex:0];
    
    if (self.segmentIndex == SegmentIndexTypeBirthdaySort) {
        NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:person.dateOfBirth];
        NSInteger year = [dc year];
        NSString *stringYear = [NSString stringWithFormat:@"%ld", (long)year];
        return stringYear;
    }else if (self.segmentIndex == SegmentIndexTypeFirstNameSort) {
        return [person.firstName substringToIndex:1];
    }else{
        return [person.lastName substringToIndex:1];
    }
    
    /*switch (month) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            return nil;
            break;
    }*/
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchingArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.searchingArray[section];
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSArray *array = self.searchingArray[indexPath.section];

    Person *somePerson = array[indexPath.row];
    
    cell.textLabel.text = somePerson.fullName;
    
    NSString *birthday = [self.dateFormatter stringFromDate:somePerson.dateOfBirth];
    
    cell.detailTextLabel.text = birthday;
        
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange: %@", searchBar.text);
    
   self.searchingArray = [self createSectionWithSearchingFromArray:self.commonArray withFilter:searchText];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}


@end
