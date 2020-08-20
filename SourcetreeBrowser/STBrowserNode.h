//
//  STBrowserNode.h
//  SourcetreeBrowser
//
//  Created by dacaiguoguo on 2020/8/20.
//  Copyright © 2020 dacaiguoguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTreeNode.h"

@interface STBrowserNode : STTreeNode<NSCoding>
@property (nonatomic, assign) int modifiedFiles;
@property (nonatomic, copy) NSString *repoIconUrl;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *doc;
@property (nonatomic, assign) BOOL canRename;
@property (nonatomic, assign) BOOL cloneFailed;
@property (nonatomic, assign) float cloneProgress;
@property (nonatomic, copy) NSString *warningText;

@property (strong, nonatomic) NSNumber *hashValue;

@property (strong, nonatomic) NSNumber *repositoryType;
- (NSString *)cleanPath;
@end
