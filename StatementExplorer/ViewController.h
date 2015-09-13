//
//  ViewController.h
//  MyFirstMacApp
//
//  Created by Muhammed Nurkerim on 11/09/2015.
//  Copyright (c) 2015 Muhammed Nurkerim. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CHCSVParser.h"

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, NSControlTextEditingDelegate, CHCSVParserDelegate>

@property (nonatomic) NSMutableArray *filteredStatement;
@property (nonatomic) NSMutableArray *statement;
@property (nonatomic) double totalAmount;
@property (nonatomic) double totalCreditAmount;

@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSTextField *totalCreditLabel;
@property (weak) IBOutlet NSTableView *statementTable;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSDatePicker *fromDate;
@property (weak) IBOutlet NSDatePicker *toDate;

- (IBAction)openFile:(id)sender;
- (IBAction)filterButton:(id)sender;

@end

