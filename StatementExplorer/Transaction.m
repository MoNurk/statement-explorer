//
//  Transaction.m
//  MyFirstMacApp
//
//  Created by Muhammed Nurkerim on 13/09/2015.
//  Copyright (c) 2015 Muhammed Nurkerim. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

- (instancetype)initWithTransactionDate:(NSDate*)date
                                   type:(NSString*)aType
                               sortCode:(NSString*)aSortcode
                          accountNumber:(NSString*)anAccountNumber
                            description:(NSString*)aDescription
                            debitAmount:(double)aDebitAmount
                           creditAmount:(double)aCreditAmount
                                balance:(double)aBalance
{
    self = [super init];
    if (self) {
        _transactionDate = date;
        _type = aType;
        _sortCode = aSortcode;
        _accountNumber = anAccountNumber;
        _transactionDescription = aDescription;
        _debitAmount = aDebitAmount;
        _creditAmount = aCreditAmount;
        _balance = aBalance;
    }
    return self;
}

@end
