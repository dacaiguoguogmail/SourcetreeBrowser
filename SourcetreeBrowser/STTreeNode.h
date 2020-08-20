//
//  STTreeNode.h
//  SourcetreeBrowser
//
//  Created by dacaiguoguo on 2020/8/20.
//  Copyright © 2020 dacaiguoguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STTreeNode : NSObject

@property (strong, nonatomic) NSMutableArray *children;

@property (strong, nonatomic) id parent;

@property (strong, nonatomic) NSNumber *isLeaf;
@property (nonatomic, strong) NSString *name;

@end
