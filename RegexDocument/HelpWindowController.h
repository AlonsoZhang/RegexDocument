//
//  HelpWindowController.h
//  RegexDocument
//
//  Created by Alonso on 2018/5/29.
//  Copyright © 2018 Alonso. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HelpWindowController : NSWindowController<NSTableViewDelegate,NSTableViewDataSource>

@property NSMutableArray *HelpTableContents;
@property (weak) IBOutlet NSScrollView *HelpView;
@property (weak) IBOutlet NSTableView *HelpTableView;

@end
