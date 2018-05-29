//
//  ViewController.m
//  RegexDocument
//
//  Created by Alonso on 2018/5/28.
//  Copyright © 2018 Alonso. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear{
    self.tableContentsDemo = [NSMutableArray new];
    self.tableContents = [NSMutableArray new];
    self.FilePathContents = @"";
}

- (IBAction)HelpBtn:(id)sender
{
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

//正则获取数组
-(NSMutableArray *)findinString:(NSString *)TargetString withregex:(NSString *) regexString
{
    NSError *error;
    NSString *pattern = [NSString stringWithFormat:@"%@",regexString];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSMutableArray *temparr = [NSMutableArray new];
    if (regex != nil)
    {
        NSArray *array = [regex matchesInString:TargetString options:0 range:NSMakeRange(0, TargetString.length)];
        for (NSTextCheckingResult* b in array)
        {
            NSString * tmp = [TargetString substringWithRange:b.range] ;
            if (tmp.length > 0)
            {
                [temparr addObject:tmp];
            }
        }
        return temparr;
    }
    return nil;
}

//正则获取字符串
-(NSString *)findFirstinString:(NSString *)TargetString withregex:(NSString *) regexString
{
    NSError *error;
    NSString *pattern = [NSString stringWithFormat:@"%@",regexString];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (regex != nil)
    {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:TargetString options:0 range:NSMakeRange(0, TargetString.length)];
        if (firstMatch != nil)
        {
            NSString *result=[TargetString substringWithRange:firstMatch.range];
            return result;
        }
    }
    return @"";
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row;
{
    if (![tableView.identifier isEqualToString:@"TableViewDemo"]){
        //有换行符则显示多行
        if ([[[self.tableContents objectAtIndex:row] objectForKey:@"CONTENT"] length] > 0)
        {
            NSString *str = [[self.tableContents objectAtIndex:row] objectForKey:@"CONTENT"];
            NSArray *arr = [str componentsSeparatedByString:@"\r"];
            if (arr.count > 0)
            {
                return  arr.count * 16.0;
            }
        }
    }
    return 16.0;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if ([tableView.identifier isEqualToString:@"TableViewDemo"])
    {
        return [self.tableContentsDemo count];
    }else
    {
        return [self.tableContents count];
    }
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
    if ([tableView.identifier isEqualToString:@"TableViewDemo"])
    {
        textField.stringValue  = [[self.tableContentsDemo objectAtIndex:row] objectForKey:[tableColumn identifier]];
    }else
    {
        textField.stringValue  = [[self.tableContents objectAtIndex:row] objectForKey:[tableColumn identifier]];
    }
    return textField;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    if ([tableView.identifier isEqualToString:@"TableView"])
    {
        if ([[[self.tableContents objectAtIndex:row] objectForKey:@"ROW"] length] > 0)
        {
            NSString *message = [NSString stringWithFormat:@"\n%@ : %@\n\n",[[self.tableContents objectAtIndex:row] objectForKey:@"CONTENT"],[[self.tableContents objectAtIndex:row] objectForKey:@"ROW"]];
            [self showAlertViewWithInform:message];
        }
    }
    return true;
}

//匹配正则，输出每一次结果
- (IBAction)OKDemo:(id)sender
{
    NSString *TestString = [NSString stringWithFormat:@"%@", self.TestStringDemo.string];
    NSString *pattern = self.PreicateDemo.stringValue;
    if ([TestString length] > 0 && [pattern length] > 0)
    {
        self.tableContentsDemo  = [NSMutableArray new];
        NSMutableArray *ArrayDemo = [self findinString:TestString withregex:pattern];
        for (int i = 0 ; i < ArrayDemo.count; i++)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"<%d>",i],[ArrayDemo objectAtIndex:i],@"1"] forKeys:@[@"NO",@"CONTENT",@"COUNT"]];
            [self.tableContentsDemo addObject:dic];
        }
        [self.TableViewDemo reloadData];
    }
    [self.OutputCSV setEnabled:false];
}

//统计正则匹配结果的次数
- (IBAction)CalcCount:(NSButton *)sender {
    [self OKDemo:_okdemoBtn];
    NSMutableDictionary *newDicDemo = [[NSMutableDictionary alloc]init];
    for (NSMutableDictionary * eachword in self.tableContentsDemo) {
        NSString * eachwordname = [eachword objectForKey:@"CONTENT"];
        if ([newDicDemo objectForKey:eachwordname]){
            NSString * newcount = [NSString stringWithFormat:@"%ld",[[newDicDemo objectForKey:eachwordname]integerValue] + 1];
            [newDicDemo setObject:newcount forKey:eachwordname];
        }else{
            [newDicDemo setObject:@"1" forKey:eachwordname];
        }
    }
    int i = 0;
    [self.tableContentsDemo removeAllObjects];
    for (NSString * content in [newDicDemo allKeys]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"<%d>",i],content,[newDicDemo objectForKey:content]] forKeys:@[@"NO",@"CONTENT",@"COUNT"]];
        i = i + 1;
        [self.tableContentsDemo addObject:dic];
    }
    [self.TableViewDemo reloadData];
    [self.OutputCSV setEnabled:true];
}

//将结果输出CSV
- (IBAction)OutputCSV:(NSButton *)sender {
    if (self.tableContentsDemo.count > 0) {
        NSMutableArray * outputArr = self.tableContentsDemo;
        [outputArr sortUsingComparator: ^NSComparisonResult (NSDictionary *dic1, NSDictionary *dic2) {
            NSNumber *number1 = [NSNumber numberWithInteger:[[dic2 objectForKey:@"COUNT"]integerValue]];
            NSNumber *number2 = [NSNumber numberWithInteger:[[dic1 objectForKey:@"COUNT"]integerValue]];
            return [number1 compare:number2];
        }];
        NSDateFormatter *nameDateFormatter = [[NSDateFormatter alloc] init];
        [nameDateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *fileName = [NSString stringWithFormat:@"%@Count.csv", [nameDateFormatter stringFromDate:[NSDate date]]];
        NSString *csvContent;
        csvContent = @"Word,Count\n";
        for (NSDictionary *each in outputArr) {
            csvContent = [NSString stringWithFormat:@"%@%@,%@\n",csvContent,[each objectForKey:@"CONTENT"],[each objectForKey:@"COUNT"]];
        }
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
        [fm createFileAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:fileName] contents:[csvContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
}

- (IBAction)ChooseFilePath:(id)sender
{
    NSButton *btn = (NSButton *)sender;
    if (btn.tag == 100)
    {
        self.FilePath1.stringValue = [self ChooselogPath];
    }
    else if (btn.tag == 200)
    {
        self.FilePath2.stringValue = [self ChooselogPath];
    }else
    {
        self.FilePath.stringValue = [self ChooselogPath];
        self.FilePathContents = [NSString stringWithContentsOfFile:self.FilePath.stringValue encoding:NSUTF8StringEncoding error:nil];
        if (self.FilePathContents.length == 0)
        {
            NSData *logData = [[NSData alloc] initWithContentsOfFile:self.FilePath.stringValue];
            if ([logData length] > 0)
            {
                logData = [self replaceNoUtf8:logData];
                self.FilePathContents = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
            }
        }
    }
}

-(NSString *)ChooselogPath
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"]]];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:@[@"txt",@"log"]];
    [panel setAllowsOtherFileTypes:NO];
    if ([panel runModal] == NSModalResponseOK)
    {
        NSString *path = [panel.URLs.firstObject path];
        return  path;
    }
    return @"";
}

- (NSData *)replaceNoUtf8:(NSData *)data
{
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    return md;
}

//找到正则匹配的行数
- (IBAction)SearchPattern:(id)sender
{
    if (self.FilePathContents.length > 0 && self.SearchPattern.stringValue.length > 0)
    {
        NSString *SearchPattern = self.SearchPattern.stringValue;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.tableContents = [NSMutableArray new];
            NSArray *logContentsArray = [self.FilePathContents componentsSeparatedByString:@"\n"];
            NSString *Content = [self findFirstinString:self.FilePathContents withregex:[NSString stringWithFormat:@".*%@.*",SearchPattern]];
            if ([Content length] > 0){
                NSUInteger index = [logContentsArray indexOfObject:Content];
                [self.tableContents addObject:[NSDictionary dictionaryWithObjects:@[@"<1>",Content,[NSString stringWithFormat:@"%lu",index+1]] forKeys:@[@"NO",@"CONTENT",@"ROW"]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.TableView reloadData];
                    [self.RowsLeft setIntValue:[[NSString stringWithFormat:@"%ld",index]intValue]+500];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlertViewWithInform:@"No string match regex!"];
                });
            }
        });
    }else
    {
        [self showAlertViewWithInform:@"Please choose file path!!!"];
        [self.FilePath becomeFirstResponder];
    }
}

//删除指定行数后的内容并保存
- (IBAction)SaveAfterRowsDeleted:(id)sender
{
    if ([self.RowsLeft.stringValue length] > 0 && self.FilePathContents.length > 0 && [self.FilePath.stringValue length] > 0)
    {
        NSString *path = self.FilePath.stringValue;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *newContents = @"";
            NSArray *logContentsArray = [self.FilePathContents componentsSeparatedByString:@"\n"];
            __block int leftRow ;
            dispatch_sync(dispatch_get_main_queue(), ^{
                leftRow =  self.RowsLeft.intValue;
            });
            NSArray *newlogContentsArray = [logContentsArray subarrayWithRange:NSMakeRange(0, leftRow)];
            newContents = [newlogContentsArray componentsJoinedByString:@"\n"];
            [newContents writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertViewWithInform:@"Save successful!!!"];
            });
        });
    }else
    {
        [self showAlertViewWithInform:@"Please choose file path and input the row number!!!"];
        [self.RowsLeft becomeFirstResponder];
    }
}

//查找匹配的正则
- (IBAction)SearchPatternDeleted:(id)sender
{
    self.FilePathContents = [NSString stringWithContentsOfFile:self.FilePath.stringValue encoding:NSUTF8StringEncoding error:nil];
    if (self.FilePathContents.length == 0)
    {
        NSData *logData = [[NSData alloc] initWithContentsOfFile:self.FilePath.stringValue];
        if ([logData length] > 0)
        {
            logData = [self replaceNoUtf8:logData];
            self.FilePathContents  = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        }
    }
    if (self.FilePathContents.length > 0)
    {
        if (self.RemovePattern.stringValue.length > 0)
        {
            self.tableContents = [NSMutableArray new];
            NSMutableArray *MatchArray = [self findinString:self.FilePathContents withregex:self.RemovePattern.stringValue];
            for (int i = 0 ; i < MatchArray.count; i++)
            {
                [self.tableContents addObject:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"<%d>",i+1],[MatchArray objectAtIndex:i],@""] forKeys:@[@"NO",@"CONTENT",@"ROW"]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.TableView reloadData];
            });
        }else
        {
            [self showAlertViewWithInform:@"Please input the regex rule want to delete!!!"];
            [self.RemovePattern becomeFirstResponder];
        }
    }else
    {
        [self showAlertViewWithInform:@"Please choose file path!!!"];
        [self.FilePath becomeFirstResponder];
    }
}

- (IBAction)SearchPatternShowRows:(id)sender
{
    self.FilePathContents = [NSString stringWithContentsOfFile:self.FilePath.stringValue encoding:NSUTF8StringEncoding error:nil];
    if (self.FilePathContents.length == 0)
    {
        NSData *logData = [[NSData alloc] initWithContentsOfFile:self.FilePath.stringValue];
        if ([logData length] > 0)
        {
            logData = [self replaceNoUtf8:logData];
            self.FilePathContents  = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        }
    }
    if (self.FilePathContents.length > 0)
    {
        if (self.RemovePattern.stringValue.length > 0)
        {
            self.tableContents = [NSMutableArray new];
            NSMutableArray * MatchArray = [self findinString:self.FilePathContents withregex:self.RemovePattern.stringValue];
            //            for (int i = 0 ; i < MatchArray.count; i++)
            //            {
            //                [self.tableContents addObject:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"<%d>",i+1],[MatchArray objectAtIndex:i],@""] forKeys:@[@"NO",@"CONTENT",@"ROW"]]];
            //            }
            
            NSString *logContents = self.FilePathContents;
            NSMutableArray *resultArray = [NSMutableArray new];
            while ([[self findFirstinString:logContents withregex:self.RemovePattern.stringValue] length] > 0 )
            {
                NSString *MatchString = [self findFirstinString:logContents withregex:self.RemovePattern.stringValue];
                NSArray *logContentsArray = [logContents componentsSeparatedByString:@"\n"];
                for (int i = 0 ; i < logContentsArray.count ; i++)
                {
                    NSString *logContentsElement = [logContentsArray objectAtIndex:i];
                    if ([logContentsElement containsString:MatchString])
                    {
                        [resultArray addObject:[NSDictionary dictionaryWithObjects:@[MatchString,[NSString stringWithFormat:@"%d",i+1]] forKeys:@[@"Content",@"Row"]]];
                        NSUInteger length = NSMaxRange([logContents rangeOfString:MatchString]);
                        logContents = [logContents stringByReplacingOccurrencesOfString:MatchString withString:@"" options:0 range:NSMakeRange(0, length)];
                        break;
                    }
                }
            }
            NSMutableDictionary *NewResultDictionary = [NSMutableDictionary new];
            for (int i = 0; i < resultArray.count; i++)
            {
                NSDictionary *dic = [resultArray objectAtIndex:i];
                NSString *content = [dic objectForKey:@"Content"];
                NSString *row = [dic objectForKey:@"Row"];
                if ([NewResultDictionary.allKeys containsObject:content])
                {
                    NSString *NewRow = [NSString stringWithFormat:@"%@,%@",[NewResultDictionary objectForKey:content],row];
                    [NewResultDictionary setObject:NewRow forKey:content];
                }else
                {
                    [NewResultDictionary setObject:row forKey:content];
                }
            }
            int i = 1;
            for (NSString *Content in NewResultDictionary.allKeys)
            {
                [self.tableContents addObject:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"<%d>",i],Content,[NewResultDictionary objectForKey:Content]] forKeys:@[@"NO",@"CONTENT",@"ROW"]]];
            }
            NSLog(@"%@",self.tableContents );
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.TableView reloadData];
            });
        }else
        {
            [self showAlertViewWithInform:@"Please input the regex rule want to delete!!!"];
            [self.RemovePattern becomeFirstResponder];
        }
    }else
    {
        [self showAlertViewWithInform:@"Please choose file path!!!"];
        [self.FilePath becomeFirstResponder];
    }
}

- (IBAction)SaveAfterPatternDeleted:(id)sender
{
    self.FilePathContents = [NSString stringWithContentsOfFile:self.FilePath.stringValue encoding:NSUTF8StringEncoding error:nil];
    
    if (self.FilePathContents.length == 0)
    {
        NSData *logData = [[NSData alloc] initWithContentsOfFile:self.FilePath.stringValue];
        
        if ([logData length] > 0)
        {
            logData = [self replaceNoUtf8:logData];
            self.FilePathContents  = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        }
    }
    
    if (self.FilePathContents.length > 0)
    {
        if (self.RemovePattern.stringValue.length > 0)
        {
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.RemovePattern.stringValue options:0 error:&error];
            
            if (regex != nil)
            {
                NSString *newContents = [regex stringByReplacingMatchesInString:self.FilePathContents options:0 range:NSMakeRange(0, [self.FilePathContents length]) withTemplate:@""];
                
                [newContents writeToFile:self.FilePath.stringValue atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [self showAlertViewWithInform:@"文件保存成功 !!!"];
                               });
                
            }
            
            
            
        }else
        {
            [self showAlertViewWithInform:@"请输入需要删除的正则表达式 !!!"];
            [self.RemovePattern becomeFirstResponder];
        }
        
        
    }else
    {
        [self showAlertViewWithInform:@"请先选择文件路径 !!!"];
        [self.FilePath becomeFirstResponder];
    }
    
    
}
- (IBAction)SaveAtLast:(id)sender
{
    if ([self.FilePath1.stringValue length] > 0 && [self.FilePath2.stringValue length] > 0)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:self.FilePath1.stringValue] && [fm fileExistsAtPath:self.FilePath2.stringValue])
        {
            NSString *contents1 = [self ReadFile:self.FilePath1.stringValue];
            NSString *contents2 = [self ReadFile:self.FilePath2.stringValue];
            
            if (contents1.length > 0 && contents2.length > 0)
            {
                NSArray *contentsArray1 = [contents1 componentsSeparatedByString:@"\n"];
                NSArray *contentsArray2 = [contents2 componentsSeparatedByString:@"\n"];
                
                NSMutableArray *newcontentsArray1 = [NSMutableArray arrayWithArray:contentsArray1];
                NSMutableArray *newcontentsArray2 = [NSMutableArray arrayWithArray:contentsArray2];
                
                
                for (NSString *Content in contentsArray1)
                {
                    if ([newcontentsArray2 containsObject:Content])
                    {
                        [newcontentsArray1 removeObject:Content];
                        [newcontentsArray2 removeObject:Content];
                        
                    }
                }
                
                NSString *newContent1 = [newcontentsArray1 componentsJoinedByString:@"\n"];
                NSString *newContent2 = [newcontentsArray2 componentsJoinedByString:@"\n"];
                
                
                [newContent1 writeToFile:self.FilePath1.stringValue atomically:YES encoding:NSUTF8StringEncoding error:nil];
                [newContent2 writeToFile:self.FilePath2.stringValue atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [self showAlertViewWithInform:@"文件保存成功 !!!"];
                               });
                
                
                
            }else
            {
                [self showAlertViewWithInform:@"文件无法正确读取，请重新选择 !!!"];
            }
            
        }else
        {
            [self showAlertViewWithInform:@"请先选择正确的文件路径 !!!"];
        }
        
    }else
    {
        [self showAlertViewWithInform:@"请先选择文件路径 !!!"];
    }
    
}


-(NSString *)ReadFile:(NSString *) path
{
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if (contents.length == 0)
    {
        NSData *logData = [[NSData alloc] initWithContentsOfFile:path];
        
        if ([logData length] > 0)
        {
            logData = [self replaceNoUtf8:logData];
            contents  = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        }
    }
    
    return contents;
}

-(void)showAlertViewWithInform:(NSString *)InformativeText
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Notice"];
    [alert setInformativeText:InformativeText];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert runModal];
}


@end
