//
//  MYTestNotARCBlock.m
//  MYTestBlock
//
//  Created by yemingyu on 2/8/16.
//  Copyright © 2016 yemingyu. All rights reserved.
//

#import "MYTestNotARCBlock.h"

typedef int(^MYCompletion)(void);

@implementation MYTestNotARCBlock

- (void)testStorage
{
    int a = 10;
    MYCompletion testGloble = ^(void){
        return a;
    };
    MYCompletion testGlobleCopy = Block_copy(testGloble);
//    Block_release(testGlobleCopy);
//    Block_release(testGlobleCopy);
//    [testGlobleCopy release];
//    [testGlobleCopy release];
//    [testGloble release];
    int b = testGloble();
    
    MYCompletion testStack = func();
    int c = testStack();
    testVariableStoragec();
}

MYCompletion func()
{
    int a = 10;
    MYCompletion result = ^(void){
        return a;
    };
    return result;
}

void testVariableStoragec()
{
    int a = 123;
    __block int b = 123;
    NSLog(@"%@", @"=== block copy前");
    NSLog(@"&a = %p, &b = %p", &a, &b);
    
    void(^block)() = ^{
        NSLog(@"%@", @"=== Block");
        NSLog(@"&a = %p, &b = %p", &a, &b);
        NSLog(@"a = %d, b = %d", a, b = 456);
    };
    block = [block copy];
    block();
    
    NSLog(@"%@", @"=== block copy后");
    NSLog(@"&a = %p, &b = %p", &a, &b);
    NSLog(@"a = %d, b = %d", a, b);
    
    [block release];
}

@end
