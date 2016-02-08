//
//  ViewController.m
//  MYTestBlock
//
//  Created by yemingyu on 2/5/16.
//  Copyright © 2016 yemingyu. All rights reserved.
//

#import "ViewController.h"
#import "MYTestNotARCBlock.h"

NSInteger CounterGlobal;
static NSInteger CounterStatic;

typedef int(^MYCompletion)(void);

@interface ViewController ()
@property (nonatomic, copy) MYCompletion testBlock;
@property (nonatomic, strong) NSString *str;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testAccess];
    [self testNest];
    dontDoThis();
    dontDoThisEither();
    [self testStorage];
    [self testNotARCStorage];
    [self testRetainCycle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testAccess
{
    NSInteger localCounter = 42;
    __block char localCharacter;
    NSString *str = @"ymy";
    
    void (^aBlock)(void) = ^(void) {
        ++CounterGlobal;
        ++CounterStatic;
        CounterGlobal = localCounter; // localCounter fixed at block creation
        localCharacter = 'a'; // sets localCharacter in enclosing scope
        //localCounter = 1;
        NSLog(@"str = %@", str);
    };
    
    ++localCounter; // unseen by the block
    localCharacter = 'b';
    str = @"ymy_def";
    NSString *test = @"test";
    aBlock(); // execute the block
    // localCharacter now 'a'
}

- (void)testNest
{
    NSInteger a = 10;
    void (^aBlock)(void) = ^{
        void (^bBlock)(void) = ^(void) {
            NSLog(@"a = %ld", (long)a);
        };
        bBlock();
    };
    
    aBlock(); // execute the block
}

- (void)testStorage
{
    MYCompletion testGloble = ^(void){
        return 1234;
    };
    MYCompletion testGlobleCopy = [testGloble copy];
    
    int a = 10;
    MYCompletion testMalloc = ^(void){
        return a;
    };
    MYCompletion testMallocCopy = [testMalloc copy];
    
//    aBlock(); // execute the block
}

//void startWithCompletion:(MYCompletion)

void dontDoThis() {
    void (^blockArray[3])(void);  // an array of 3 block references
    
    for (int i = 0; i < 3; ++i) {
        blockArray[i] = ^{ printf("hello, %d\n", i); };
        // WRONG: The block literal scope is the "for" loop.
    }
    blockArray[0]();
    blockArray[1]();
    blockArray[2]();
}

void dontDoThisEither() {
    void (^block)(void);
    
    long i = random();
//    if (i > 1000) {
        block = ^(){ printf("got i at: %ld\n", i); };
        // WRONG: The block literal scope is the "then" clause.
//    }
    // ...
    block();
}

- (void)testNotARCStorage
{
    MYTestNotARCBlock *cls = [[MYTestNotARCBlock alloc] init];
    [cls testStorage];
}

- (void)testRetainCycle
{
    NSMutableArray *firstArray=[[NSMutableArray alloc]init];
    NSMutableArray *secondArray=[[NSMutableArray alloc]init];
    [firstArray addObject:secondArray];
    [secondArray addObject:firstArray];
    
    __weak typeof(self) weakSelf = self;
    self.testBlock = ^(void)
    {
        __strong typeof(self) strongSelef = weakSelf;
        //使用weakSelf访问self成员
        [strongSelef anotherFunc];
        return 0;
    };
    self.testBlock();
}

- (void)anotherFunc
{
    self.str = @"test";
}

@end
