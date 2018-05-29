//
//  HelpWindowController.m
//  RegexDocument
//
//  Created by Alonso on 2018/5/29.
//  Copyright © 2018 Alonso. All rights reserved.
//

#import "HelpWindowController.h"

@interface HelpWindowController ()

@end

@implementation HelpWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.HelpTableContents = [NSMutableArray new];
    NSString *HelpList = [[NSBundle mainBundle] pathForResource:@"PatternList" ofType:@"plist"];
    self.HelpTableContents = [[NSMutableArray alloc] initWithContentsOfFile:HelpList];
    [self.HelpTableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.HelpTableContents count];
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTextField *textField = [tableView makeViewWithIdentifier:@"TextField" owner:self];
    if (textField == nil)
    {
        textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [textField setBordered:NO];
        [textField setEditable:NO];
        [textField setDrawsBackground:NO];
        textField.identifier = @"TextField";
    }
    textField.stringValue  = [[self.HelpTableContents objectAtIndex:row] objectForKey:[tableColumn identifier]];
    return textField;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    NSString *value = [[self.HelpTableContents objectAtIndex:row] objectForKey:@"PATTERN"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_name" object:value];
    return true;
}

@end
