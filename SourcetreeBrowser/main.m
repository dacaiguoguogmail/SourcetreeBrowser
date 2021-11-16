//
//  main.m
//  SourcetreeBrowser
//
//  Created by dacaiguoguo on 2020/8/20.
//  Copyright © 2020 dacaiguoguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBrowserNode.h"
#import "STTreeNode.h"

int removeRepeatLabel(NSArray<STBrowserNode *> *originBrowsers3, NSArray<STBrowserNode *> **outPutBrowsers);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        system("osascript -e 'quit app \"Sourcetree\"'>/dev/null 2>&1");

        NSString *stBrowserPath = @"~/Library/Application Support/SourceTree/browser.plist";
        NSString *configPath = stBrowserPath.stringByStandardizingPath;
        _Pragma("clang diagnostic push")
        _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
        _Pragma("clang diagnostic ignored \"-Wunused-parameter\"")

        NSArray *originBrowsers = [NSKeyedUnarchiver unarchiveObjectWithFile:configPath];
        
        NSMutableSet *groupNameSet = [NSMutableSet set];
        NSMutableDictionary *groupInfo = [NSMutableDictionary dictionary];

        NSArray *newBrowsers = nil;
        removeRepeatLabel(originBrowsers, &newBrowsers);
        
        NSFileManager *fn = [NSFileManager defaultManager];
        NSString *logFileName = [NSString stringWithFormat:@"%@_%@.log", [[NSProcessInfo processInfo] globallyUniqueString], @"SourcetreeBrowser"];
        NSString *logFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:logFileName];

        for (STBrowserNode *nodeLeaf in newBrowsers) {
            NSString *cmdString = [NSString stringWithFormat:@"git -C '%@' config remote.origin.url >'%@'", nodeLeaf.path, logFilePath];
            int res = system(cmdString.UTF8String);
            if (res == 0) {
                NSString *gitRepoUrl = [[NSString stringWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSURL *url = [NSURL URLWithString:gitRepoUrl];
                nodeLeaf.repoIconUrl = [url.path stringByDeletingLastPathComponent].lastPathComponent;
            } else {
                nodeLeaf.repoIconUrl = [nodeLeaf.path stringByDeletingLastPathComponent].lastPathComponent;
                printf("%s\n", nodeLeaf.path.UTF8String);
            }
            if (nodeLeaf.repoIconUrl) {
                [groupNameSet addObject:nodeLeaf.repoIconUrl];
            }
        }
        [fn removeItemAtPath:logFilePath error:nil];

        for (NSString *key in groupNameSet) {
            STBrowserNode *model = [[STBrowserNode alloc] init];
            model.name = key;
            model.isLeaf = @(0);// 组
            model.repositoryType = @(255);// 组
            [groupInfo setObject:model forKey:key];
        }
        NSMutableArray *newBrowsersMut = newBrowsers.mutableCopy;
        for (STBrowserNode *node in newBrowsers) {
            STBrowserNode *model = [groupInfo objectForKey:node.repoIconUrl];
            if (model) {
                [model.children addObject:node];
                [newBrowsersMut removeObject:node];
            }
        }
        [newBrowsersMut addObjectsFromArray:groupInfo.allValues];
        [newBrowsersMut sortUsingComparator:^NSComparisonResult(STBrowserNode *obj1, STBrowserNode *obj2) {
            return [obj1.name compare:obj2.name];
        }];
        // 7.归档
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        _Pragma("clang diagnostic pop")
        archiver.outputFormat = NSPropertyListXMLFormat_v1_0; // 以二进制的形式，XML也行
        [archiver encodeObject:newBrowsersMut forKey:@"root"];
        [archiver finishEncoding];

        BOOL success = [data writeToFile:configPath atomically:YES];
        if (success) {
            printf("写入成功,重新打开Sourcetree。\n");
            system("open -b com.torusknot.SourceTreeNotMAS");
            return 0;
        } else {
            printf("写入失败,重新打开Sourcetree。\n");
        }
    }
    return 0;
}

int removeRepeatLabel(NSArray<STBrowserNode *> *originBrowsers3, NSArray<STBrowserNode *> **outPutBrowsers) {

    NSFileManager *fn = [NSFileManager defaultManager];
    NSMutableSet *nodeSet = [NSMutableSet set];
    BOOL isDirectory = NO;
    // 删除文件夹没有的标签。去掉重复的标签
    for (STBrowserNode *node in originBrowsers3) {
        if (node.path.length == 0 && node.children.count > 0) {
            for (STBrowserNode *nodeLeaf in node.children) {
                if ([fn fileExistsAtPath:nodeLeaf.path isDirectory:&isDirectory] && isDirectory) {
                    [nodeSet addObject:nodeLeaf];
                } else {
                    NSLog(@"nodeLeaf:%@", nodeLeaf);
                }
            }
        }
        if (node.path.length > 0) {
            if ([fn fileExistsAtPath:node.path isDirectory:&isDirectory] && isDirectory) {
                [nodeSet addObject:node];
            } else {
                NSLog(@"node.path:%@", node.path);
            }
        } else {
            NSLog(@"node:%@", node);
        }
    }
    NSMutableArray *newBrowsers2 = [NSMutableArray arrayWithArray:nodeSet.allObjects];
    *outPutBrowsers = newBrowsers2;
    //    NSLog(@"project:\n%@",newBrowsers);
    //    NSLog(@"project count:%@",@(newBrowsers.count));
    if (newBrowsers2.count == originBrowsers3.count) {
        printf("没有重复和文件夹不存在的标签\n");
        return 0;
    }
    return 0;
}
