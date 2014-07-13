//
//  BBCXMLParserOperation.m
//  BBCNews
//
//  Created by Sergey Shulga on 7/9/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import "BBCXMLParserOperation.h"

@interface BBCXMLParserOperation () <NSXMLParserDelegate>

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) NSMutableArray *workingArray;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSArray *elementsToParse;
@property (nonatomic, retain) NSMutableDictionary *parsedEntityDict;
@property (nonatomic, assign) BOOL storingCharacterData;

@property (nonatomic, assign) BOOL isCancelled;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isExecuting;

@property (nonatomic, copy)   void (^callback)(NSArray *parsedDicts);

@end

@implementation BBCXMLParserOperation

- (id)initWithDataToParse:(NSData *)data complationBlock:(void (^)(NSArray *))callback{
    self = [super init];
    
    if (self) {
        self.dataToParse = data;
        self.elementsToParse = @[@"item", @"title", @"description", @"pubDate",@"link", @"media:thumbnail width=\"144\" height=\"81\" url"];
        self.callback = callback;
    }
    
    return self;
}

- (void)dealloc{
    [self.parser release];
    [self.dataToParse release];
    [self.workingArray release];
    [self.workingPropertyString release];
    [self.elementsToParse release];
    [self.parsedEntityDict release];
    
    [super dealloc];
}

#pragma mark - operations methods

- (void)start {
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        self.isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    self.isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main{
    
    self.workingPropertyString = [NSMutableString string];
    self.workingArray = [NSMutableArray array];
    
    self.parser = [[NSXMLParser alloc] initWithData:self.dataToParse];
    [self.parser setDelegate:self];
    [self.parser parse];
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = NO;
    self.callback(self.workingArray);
    _isFinished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)cancel{
    [self.parser abortParsing];
    [self willChangeValueForKey:@"isCancelled"];
    self.isCancelled = YES;
    [self didChangeValueForKey:@"isCancelled"];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"])
    {
        self.parsedEntityDict = [[NSMutableDictionary alloc] init];
    } else if ([elementName isEqualToString:@"media:thumbnail"] && [attributeDict[@"width"] isEqualToString:@"66"]){
        self.parsedEntityDict[@"thumbnail_small"] = attributeDict[@"url"];
    } else if ([elementName isEqualToString:@"media:thumbnail"] && [attributeDict[@"width"] isEqualToString:@"144"]){
        self.parsedEntityDict[@"thumbnail_big"] = attributeDict[@"url"];
    }
    self.storingCharacterData = [self.elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName{
    
    if (self.parsedEntityDict)
    {
        if (self.storingCharacterData)
        {
            NSString *trimmedString = [self.workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [self.workingPropertyString setString:@""];// clear the string for next time
            
            if ([elementName isEqualToString:@"title"]){
                self.parsedEntityDict[elementName] = trimmedString;
            }
            else if ([elementName isEqualToString:@"description"]){
                self.parsedEntityDict[elementName] = trimmedString;
            }
            else if ([elementName isEqualToString:@"pubDate"]){
                self.parsedEntityDict[elementName] = trimmedString;
            } else if ([elementName isEqualToString:@"link"]){
                self.parsedEntityDict[elementName] = trimmedString;
            } else if ([elementName isEqualToString:@"media:thumbnail"]){
                self.parsedEntityDict[elementName] = trimmedString;
            }
        }
        else if ([elementName isEqualToString:@"item"]){
            [self.workingArray addObject:self.parsedEntityDict];
            self.parsedEntityDict = nil;
        }
    } else {
        [self.workingPropertyString setString:@""];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.storingCharacterData){
        [self.workingPropertyString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self completeOperation];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    [self completeOperation];
}

@end
