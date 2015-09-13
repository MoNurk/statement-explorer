//
//  ViewController.m
//  MyFirstMacApp
//
//  Created by Muhammed Nurkerim on 11/09/2015.
//  Copyright (c) 2015 Muhammed Nurkerim. All rights reserved.
//

#import "ViewController.h"
#import "Transaction.h"
#import "CHCSVParser.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    [self filterButton:self];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if ([_filteredStatement count] > 0) {
        return [_filteredStatement count];
    } else {
        return [_statement count];
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn identifier];
    
    Transaction* currentRow;
    
    if ([_filteredStatement count] > 0) {
        currentRow = [_filteredStatement objectAtIndex:row];
    } else {
        currentRow = [_statement objectAtIndex:row];
    }
    
    if ([identifier isEqualTo:@"Date"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *stringDate = [dateFormatter stringFromDate:[currentRow transactionDate]];

        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        cellView.textField.stringValue = stringDate;
        
        return cellView;
    } else if ([identifier isEqualTo:@"Type"]){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        cellView.textField.stringValue = [currentRow type];
        
        return cellView;
    } else if ([identifier isEqualTo:@"SortCode"]){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        cellView.textField.stringValue = [currentRow sortCode];
        
        return cellView;
    } else if ([identifier isEqualTo:@"AccountNumber"]){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        cellView.textField.stringValue = [currentRow accountNumber];
        
        return cellView;
    } else if ([identifier isEqualTo:@"Description"]){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"DescriptionCell" owner:self];
        cellView.textField.stringValue = [currentRow transactionDescription];
        
        return cellView;
    } else if ([identifier isEqualTo:@"Debit"]){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        cellView.textField.stringValue = [NSString stringWithFormat:@"%.02f", [currentRow debitAmount]];
        
        return cellView;
    } else if ([identifier isEqualTo:@"Credit"]){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        cellView.textField.stringValue = [NSString stringWithFormat:@"%.02f", [currentRow creditAmount]];
        
        return cellView;
    } else {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        cellView.textField.stringValue = [NSString stringWithFormat:@"%.02f", [currentRow balance]];
        
        return cellView;
    }
}

-(void)tableView:(NSTableView *)tableView sortDescriptorsDidChange: (NSArray *)oldDescriptors
{
    NSMutableArray* currentRow;
    
    if ([_filteredStatement count] > 0) {
        currentRow = _filteredStatement;
    } else {
        currentRow = _statement;
    }
    
    NSArray *newDescriptors = [tableView sortDescriptors];
    [currentRow sortUsingDescriptors:newDescriptors];
    //"results" is my NSMutableArray which is set to be the data source for the NSTableView object.
    [tableView reloadData];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    NSTableView *tableView = notification.object;
    NSLog(@"User has selected row %ld", (long)tableView.selectedRow);
}

- (IBAction)openFile:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO]; // yes if more than one dir is allowed
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            [self parseCsvFile:url];
        }
    }
}

- (IBAction)filterButton:(id)sender {
    NSString *searchTerm = [_searchField stringValue];
    _filteredStatement = [[NSMutableArray alloc] init];
    
    _totalAmount = 0;
    _totalCreditAmount = 0;
    for (Transaction* transaction in _statement) {
        NSString *description = [transaction transactionDescription];
        
        if ([searchTerm length] == 0 || [[description lowercaseString] containsString:[searchTerm lowercaseString]]) {
            if ([ViewController date:[transaction transactionDate] isBetweenDate:[_fromDate dateValue] andDate:[_toDate dateValue]]) {
                [_filteredStatement addObject:transaction];
                [self calculateTotal:[transaction debitAmount]];
                [self calculateTotalCredit:[transaction creditAmount]];
            }
        }
    }
    
    [self.statementTable reloadData];
}

- (void)calculateTotal:(double)amount {
    _totalAmount += amount;
    
    [_label setStringValue:[NSString stringWithFormat:@"Total: £%.02f", _totalAmount]];
}

- (void)calculateTotalCredit:(double)amount {
    _totalCreditAmount += amount;
    
    [_totalCreditLabel setStringValue:[NSString stringWithFormat:@"Total: £%.02f CR", _totalCreditAmount]];
}

- (void)parseCsvFile:(NSURL*)filePath {
    NSError *error = nil;
    NSMutableArray *rows = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithContentsOfCSVURL:filePath]];
    if (rows == nil) {
        //something went wrong; log the error and exit
        NSLog(@"error parsing file: %@", error);
        return;
    }
    
    [rows removeObjectAtIndex:0];
    _statement = [[NSMutableArray alloc] init];
    
    for (NSArray* array in rows) {
        NSString *date = [array objectAtIndex:0];
        NSString *description = [array objectAtIndex:4];
        NSString *debitAmount = [array objectAtIndex:5];
        NSString *creditAmount = [array objectAtIndex:6];
        NSString *balance = [array objectAtIndex:7];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yy"];
        NSDate *transactionDate = [[NSDate alloc] init];
        transactionDate = [dateFormatter dateFromString:date];
        
        Transaction* transaction = [[Transaction alloc] initWithTransactionDate:transactionDate type:[array objectAtIndex:1] sortCode:[array objectAtIndex:2] accountNumber:[array objectAtIndex:3] description:description debitAmount:[debitAmount doubleValue] creditAmount:[creditAmount doubleValue] balance:[balance doubleValue]];
        
        [_statement addObject:transaction];
    }
    
    [self.statementTable reloadData];
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

@end
