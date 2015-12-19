//
//  MCMExceptionHandler.m
//  Morione
//
//  Created by Marco Conti on 19/12/15.
//  Copyright © 2015 com.marco83. All rights reserved.
//

#import "MCMExceptionHandler.h"

NSException* __nullable MCMExecuteWithPossibleExceptionInBlock(dispatch_block_t _Nonnull block) {
    
    @try {
        if (block != nil) {
            block();
        }
    }
    @catch (NSException *exception) {
        return exception;
    }
    return nil;
}
