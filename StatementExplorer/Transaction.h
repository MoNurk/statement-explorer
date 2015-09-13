//
//  Transaction.h
//  MyFirstMacApp
//
//  Created by Muhammed Nurkerim on 13/09/2015.
//  Copyright (c) 2015 Muhammed Nurkerim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (nonatomic) NSDate* transactionDate;
@property (nonatomic) NSString* type;
@property (nonatomic) NSString* sortCode;
@property (nonatomic) NSString* accountNumber;
@property (nonatomic) NSString* transactionDescription;
@property (nonatomic) double debitAmount;
@property (nonatomic) double creditAmount;
@property (nonatomic) double balance;

- (instancetype)initWithTransactionDate:(NSDate*)date
                                   type:(NSString*)aType
                               sortCode:(NSString*)aSortcode
                          accountNumber:(NSString*)anAccountNumber
                            description:(NSString*)aDescription
                            debitAmount:(double)aDebitAmount
                           creditAmount:(double)aCreditAmount
                                balance:(double)aBalance;

@end
