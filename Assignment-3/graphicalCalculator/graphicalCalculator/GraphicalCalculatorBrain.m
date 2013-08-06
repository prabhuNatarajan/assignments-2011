//
//  GraphicalCalculatorBrain.m
//  graphicalCalculator
//
//  Created by Apple on 03/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "GraphicalCalculatorBrain.h"
#import "GraphicalCalculatorViewController.h"

@interface GraphicalCalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end
@implementation GraphicalCalculatorBrain

- (NSMutableArray *)programStack //method for operand stack
{
    if (!_programStack)_programStack = [[NSMutableArray alloc]init];
    return _programStack;
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];    
}

- (void)pushOperand:(double)operand //method for pushing the operand into stack
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}
- (double)performOperation:(NSString *)operation //method for performing operations on the operands
{
    [self.programStack addObject:operation];
    if (![self.programStack containsObject:@"a"])
    {
        return [[self class]runProgram:self.program];
    }
    else return 0;
}

- (id)program
{
    return [self.programStack copy];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    id topofstack = [stack lastObject];
    if (topofstack) [stack removeLastObject];
    if ([topofstack isKindOfClass:[NSNumber class]])
    {
        result = [topofstack doubleValue];}
    else if ([topofstack isKindOfClass:[NSString class]])
    {
        NSString *operation = topofstack;
        if ([operation isEqualToString:@"+"]) //addition operation
        {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        }
        else if ([operation isEqualToString:@"*"]) //multiplication operation
        {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        }
        else if ([@"-" isEqualToString:operation]) //subtraction operation
        {
            double subresult = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subresult;
        }
        else if ([operation isEqual:@"Sin"]) //sine operation
        {
            double sinvalue = [self popOperandOffProgramStack:stack];
            result = sin(sinvalue);
        }
        else if ([@"Cos" isEqualToString:operation]) //cos operation
        {
            double coss = [self popOperandOffProgramStack:stack];
            result = cos(coss);
        }
        else if ([@"Sqrt" isEqualToString:operation]) //square root operation
        {
            double sqrts = [self popOperandOffProgramStack:stack];
            if(sqrts) result = sqrt(sqrts);
            
        }
        else if ([@"/" isEqualToString:operation]) //division operation
        {
            double divresult = [self popOperandOffProgramStack:stack];
            if  (divresult) result = [self popOperandOffProgramStack:stack] / divresult;
        }
        else if ([@"Pi" isEqualToString:operation]) //Declaring PI Value
        {
            result = M_PI;
        }
    }
    return result;
}

+ (NSMutableSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet *variablesSetUsedInProgram = [[NSMutableSet alloc] init];
    if ([program containsObject:@"x"])
    {
        [variablesSetUsedInProgram addObject:@"x"];
    }
    return variablesSetUsedInProgram;
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) stack = [program mutableCopy];
    //loop to replace variables with conrisponding values in dictionary
    for (int i=0; i<[stack count]; i++)
    {
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"x"])
        {
            //convert NSString object to NSNumber object
            NSString *myString = [variableValues valueForKey:@"x"];
            NSNumber *myNumber = [NSNumber numberWithDouble:[myString doubleValue]];
            //replace "x" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack];
}

//check if an nsstring is an operation
+ (BOOL)isOperation:(NSString *)operation
{
    BOOL result = 0;
    NSSet *operationSet = [NSSet setWithObjects:@"+", @"-", @"*" ,@"/" ,@"Sin" ,@"Cos" ,@"Sqrt" ,@"Pi" , nil];
    if ([operationSet containsObject:operation]) result = 1;
    return result;
}

//compare two operations' priority
+ (BOOL)compareOperationPriority:(NSString *)firstOperation vs:(NSString *)secondOperation
{
    BOOL result = 0;
    NSDictionary *operationPriority = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"+", @"1", @"-", @"2", @"*", @"2", @"/", @"3", @"sin", @"3", @"cos", @"3", @"Sqrt", nil];
    int firstOperationLevel = [[operationPriority objectForKey:firstOperation] intValue];
    int secondOperationLevel;
    if (secondOperation)
    {
        secondOperationLevel = [[operationPriority objectForKey:secondOperation] intValue];
        if (firstOperationLevel>secondOperationLevel) result = 1;
    }
    return result;
}

//get rid of unnecessary parienthese by comparing the last and the secondlast operation
+ (NSString *)surpressParienthese:(NSString *)description
{
    NSMutableArray *descriptionArray = [[description componentsSeparatedByString:@" "] mutableCopy];
    
    NSString *lastOperation,*secondLastOperation;
    for (int i=[descriptionArray count]-1; i>0 && !lastOperation; i--)
    {
        if([GraphicalCalculatorBrain isOperation:[descriptionArray objectAtIndex:i]])
        {
            lastOperation=[descriptionArray objectAtIndex:i];//last operation found
            for (int j=i-1; j>0 && !secondLastOperation; j--)
            {
                if ([GraphicalCalculatorBrain isOperation:[descriptionArray objectAtIndex:j]])
                {
                    secondLastOperation = [descriptionArray objectAtIndex:j];
                }
            }
            if (![GraphicalCalculatorBrain compareOperationPriority:lastOperation vs:secondLastOperation])
            {
                [descriptionArray removeObjectAtIndex:i-1];
                [descriptionArray removeObjectAtIndex:0];
            }
        }
    }
    
    description = [[descriptionArray valueForKey:@"description"] componentsJoinedByString:@" "];
    return description;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *description;
    id topOfStack = [stack lastObject];
    [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]]) description = [topOfStack stringValue];
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        if ([[GraphicalCalculatorBrain typeOfString:topOfStack] isEqualToString:@"twoOperandOperation"])
        {
            NSString *second = [GraphicalCalculatorBrain descriptionOfTopOfStack:stack];
            NSString *first = [GraphicalCalculatorBrain descriptionOfTopOfStack:stack];
            description = [NSString stringWithFormat:@"(%@%@%@)", first, topOfStack, second];
            description = [GraphicalCalculatorBrain surpressParienthese: description];  //only two operand operation needs to surpress
        }
        if ([[GraphicalCalculatorBrain typeOfString:topOfStack] isEqualToString:@"singleOperandOperation"])
        {
            description = [NSString stringWithFormat:@"%@(%@)", topOfStack, [GraphicalCalculatorBrain descriptionOfTopOfStack:stack]];
        }
        if ([[GraphicalCalculatorBrain typeOfString:topOfStack] isEqualToString:@"noOperandOperation"])
        {
            description = [NSString stringWithFormat:@"%@", topOfStack];
        }
        if ([[GraphicalCalculatorBrain typeOfString:topOfStack] isEqualToString:@"variable"])
        {
            description = topOfStack;
        }
    }
    //check if description has "null" in the case of user pressed operation withoud operand before
    NSRange nsrange = [description rangeOfString:@"null"];
    if (nsrange.location != NSNotFound)
    {
        description = @"operand not entered";
    }
    return description;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

- (void)emptyStack
{
    [self.programStack removeAllObjects];
}

- (void)undoButton
{
    [self.programStack removeLastObject];
}

// method to determine a string's type
+ (NSString *)typeOfString:(NSString *)string
{
    NSSet *twoOperandOperation = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    NSSet *singleOperandOperation = [NSSet setWithObjects:@"Sqrt", @"Sin", @"Cos", nil];
    NSSet *noOperandOperation = [NSSet setWithObjects:@"Pi", nil];
    NSSet *variable = [NSSet setWithObjects:@"x", nil];
    if ([twoOperandOperation containsObject:string])return @"twoOperandOperation";
    else if ([singleOperandOperation containsObject:string])return @"singleOperandOperation";
    else if ([noOperandOperation containsObject:string])return @"noOperandOperation";
    else if ([variable containsObject:string])return @"variable";
    else return nil;
}

@end