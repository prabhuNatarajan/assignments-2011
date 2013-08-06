//
//  ProgramableCalculatorBrain.m
//  ProgramableCalculator
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "ProgramableCalculatorBrain.h"

@interface ProgramableCalculatorBrain ()
@property (nonatomic,strong)NSMutableArray *programStack;
@end

@implementation ProgramableCalculatorBrain

- (NSMutableArray *)programStack //method for program stack
{
    if (!_programStack)_programStack = [[NSMutableArray alloc]init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}


+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return[self descriptionOfTopOfStack:stack];
}

//check if an nsstring is an operation
+ (BOOL)isOperation:(NSString *)operation
{
    BOOL result = 0;
    NSSet *operationSet = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"Sin", @"Cos", @"Sqrt", @"Pi", nil];
    if ([operationSet containsObject:operation])result = 1;
    return result;
}

//compare two operations' priority
+ (BOOL)compareOperationPriority:(NSString *)firstOperation vs:(NSString *)secondOperation
{
    BOOL result = 0;
    NSDictionary *operationPriority = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"+", @"1", @"-", @"2", @"*", @"2", @"/", @"3", @"Sin", @"3", @"Cos", @"3", @"Sqrt", nil];
    NSInteger firstOperationLevel = [[operationPriority objectForKey:firstOperation] intValue];
    NSInteger secondOperationLevel;
    if (secondOperation)
    {
        secondOperationLevel = [[operationPriority objectForKey:secondOperation] intValue];
        if (firstOperationLevel > secondOperationLevel) result=1;
    }
    return result;
}

//avoid unnecessary parienthese by comparing last and second last operation
+ (NSString *)surpressParienthese:(NSString *)description
{
    NSMutableArray *descriptionArray = [[description componentsSeparatedByString:@" "]mutableCopy];
    NSString *lastOperation, *secondLastOperation;
    for (int i= [descriptionArray count]-1; i>0&& !lastOperation; i--)
    {
        if ([ProgramableCalculatorBrain isOperation:[descriptionArray objectAtIndex:i]])
        {
            lastOperation = [descriptionArray objectAtIndex:i];//last operation found
            for (int j=i-1; j>0&& !secondLastOperation; j--)
                {
                    if ([ProgramableCalculatorBrain isOperation:[descriptionArray objectAtIndex:j]])
                    {
                        secondLastOperation = [descriptionArray objectAtIndex:j];
                    }
                }
            if (![ProgramableCalculatorBrain compareOperationPriority:lastOperation vs:secondLastOperation])
            {
                [descriptionArray removeObjectAtIndex:i-1];
                [descriptionArray removeObjectAtIndex:0];
            }
        }
    }    
    description = [[descriptionArray valueForKey:@"description"]componentsJoinedByString:@" "];
    return description;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *description;    
    id topOfStack = [stack lastObject];
    [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]]) description = [topOfStack stringValue];
    else if([topOfStack isKindOfClass:[NSString class]])
    {
        if ([[ProgramableCalculatorBrain typeOfString:topOfStack] isEqualToString:@"twoOperandOperation"])
            {
            NSString *second = [ProgramableCalculatorBrain descriptionOfTopOfStack:stack];
            NSString *first = [ProgramableCalculatorBrain descriptionOfTopOfStack:stack];
            description = [NSString stringWithFormat:@"(%@%@%@)", first, topOfStack, second];
            description = [ProgramableCalculatorBrain surpressParienthese:description];
            }
        if ([[ProgramableCalculatorBrain typeOfString:topOfStack] isEqualToString:@"singleOperandOperation"])
            {
            description = [NSString stringWithFormat:@"%@(%@)", topOfStack, [ProgramableCalculatorBrain descriptionOfTopOfStack:stack]];
            }
        if ([[ProgramableCalculatorBrain typeOfString:topOfStack] isEqualToString:@"noOperandOperation"])
            {
            description = [NSString stringWithFormat:@"%@", topOfStack];
            }
        if ([[ProgramableCalculatorBrain typeOfString:topOfStack] isEqualToString:@"variable"])
            {
            description = topOfStack;
            }
    }
    NSRange nsrange = [description rangeOfString:@"null"];
    if (nsrange.location != NSNotFound)
        {
        description = @"operand not entered";
        }
    return description;
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

+ (double)popOperandOffProgramstack:(NSMutableArray *)stack
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
            result = [self popOperandOffProgramstack:stack] + [self popOperandOffProgramstack:stack];
        }
        else if ([operation isEqualToString:@"*"]) //multiplication operation
        {
            result = [self popOperandOffProgramstack:stack] * [self popOperandOffProgramstack:stack];
        }
        else if ([@"-" isEqualToString:operation]) //subtraction operation
        {
            double subresult = [self popOperandOffProgramstack:stack];
            result = [self popOperandOffProgramstack:stack] - subresult;
        }
        else if ([@"Sin" isEqualToString:operation]) //sine operation
        {
            double sinvalue = [self popOperandOffProgramstack:stack];
            result = sin(sinvalue);
        }
        else if ([@"Cos" isEqualToString:operation]) //cos operation
        {
            double coss = [self popOperandOffProgramstack:stack];
            result = cos(coss);
        }
        else if ([@"Sqrt" isEqualToString:operation]) //square root operation
        {
            double sqrts = [self popOperandOffProgramstack:stack];
            if(sqrts) result = sqrt(sqrts);
            
        }
        else if ([@"/" isEqualToString:operation]) //division operation
        {
            double divresult=[self popOperandOffProgramstack:stack];
            if  (divresult) result=[self popOperandOffProgramstack:stack] / divresult;
        }
        else if ([@"Pi" isEqualToString:operation]) //Declaring PI Value
        {
            result = M_PI;
        }
    }
    return result;
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) stack = [program mutableCopy];
    //loop to replace variables with conrisponding values in dictionary
    for (int i=0; i<[stack count]; i++)
    {
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"a"])
        {
            //convert NSString object to NSNumber object
            NSString *myString = [variableValues valueForKey:@"a"];
            NSNumber *myNumber = [NSNumber numberWithDouble:[myString doubleValue]];
            //replace "a" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"b"])
        {
            //convert NSString object to NSNumber object
            NSString *myString = [variableValues valueForKey:@"b"];
            NSNumber *myNumber = [NSNumber numberWithDouble:[myString doubleValue]];
            //replace "b" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"x"])
        {
            //convert NSString object to NSNumber object
            NSString *myString = [variableValues valueForKey:@"x"];
            NSNumber *myNumber = [NSNumber numberWithDouble:[myString doubleValue]];
            //replace "x" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
    }
    return [self popOperandOffProgramstack:stack];
}

+ (NSMutableSet *)variablesUsedInProgram:(id)program
{    
    NSMutableSet *variablesSetUsedInProgram = [[NSMutableSet alloc]init];
    if ([program containsObject:@"a"])
    {
        [variablesSetUsedInProgram addObject:@"a"];
    }
    if ([program containsObject:@"b"])
    {
        [variablesSetUsedInProgram addObject:@"b"];
    }
    if ([program containsObject:@"x"])
    { 
        [variablesSetUsedInProgram addObject:@"x"];
    }
    if ([variablesSetUsedInProgram count] == 0)
    {
         variablesSetUsedInProgram = nil;   
    }
    return variablesSetUsedInProgram;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramstack:stack];
}

+ (NSString *)typeOfString:(NSString *)string // method to determine a string's type
{
    NSSet *twoOperandOperation = [NSSet setWithObjects: @"+", @"-", @"*", @"/", nil];
    NSSet *singleOperandOperation = [NSSet setWithObjects: @"Sqrt", @"Sin", @"Cos", nil];
    NSSet *noOperandOperation = [NSSet setWithObjects: @"Pi", nil];
    NSSet *variable = [NSSet setWithObjects: @"a", @"b", @"x", nil];
    if ([twoOperandOperation containsObject:string]) return @"twoOperandOperation";
    else if ([singleOperandOperation containsObject:string]) return @"singleOperandOperation";
    else if ([noOperandOperation containsObject:string]) return @"noOperandOperation";
    else if ([variable containsObject:string]) return @"variable";
    else return nil;
}

- (void)undoButton //for removing the last object in the stack
{
    [self.programStack removeLastObject];
}

- (void)clearProgramStack //for clearing the program stack
{
    [self.programStack removeAllObjects];
}

@end