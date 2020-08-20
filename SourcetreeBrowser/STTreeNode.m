//
//  STTreeNode.m
//  SourcetreeBrowser
//
//  Created by dacaiguoguo on 2020/8/20.
//  Copyright © 2020 dacaiguoguo. All rights reserved.
//

#import "STTreeNode.h"

@implementation STTreeNode

- (NSMutableArray *)children {
    if (!_children) {
        
        self.children = [NSMutableArray array];
    }
    return _children;
}

- (NSString *)description {
    if (_children.count > 0) {
        return [self.name stringByAppendingFormat:@"\nchildren:%@", self.children];
    }
    return self.name;
}

@end
