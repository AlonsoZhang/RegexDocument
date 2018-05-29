//
//  ViewController.h
//  RegexDocument
//
//  Created by Alonso on 2018/5/28.
//  Copyright © 2018 Alonso. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSApplicationDelegate,NSTableViewDelegate,NSTableViewDataSource>

@property NSMutableArray *tableContentsDemo;
@property (unsafe_unretained) IBOutlet NSTextView *TestStringDemo;
@property (weak) IBOutlet NSTextField *PreicateDemo;
@property (weak) IBOutlet NSTableView *TableViewDemo;
@property (weak) IBOutlet NSTextField *FilePath;
@property (weak) IBOutlet NSTextField *SearchPattern;
@property (weak) IBOutlet NSTableView *TableView;
@property (weak) IBOutlet NSTextField *RowsLeft;
@property (weak) IBOutlet NSTextField *RemovePattern;
@property (weak) IBOutlet NSTextField *FilePath1;
@property (weak) IBOutlet NSTextField *FilePath2;
@property (weak) IBOutlet NSButton *OutputCSV;
@property (weak) IBOutlet NSButton *okdemoBtn;

@property NSString *FilePathContents;
@property NSMutableArray *tableContents;

- (IBAction)OKDemo:(id)sender;
- (IBAction)ChooseFilePath:(id)sender;
- (IBAction)SearchPattern:(id)sender;
- (IBAction)SaveAfterRowsDeleted:(id)sender;
- (IBAction)SearchPatternDeleted:(id)sender;
- (IBAction)SaveAfterPatternDeleted:(id)sender;
- (IBAction)SaveAtLast:(id)sender;
- (IBAction)HelpBtn:(id)sender;
- (IBAction)CalcCount:(NSButton *)sender;
- (IBAction)OutputCSV:(NSButton *)sender;

@end

