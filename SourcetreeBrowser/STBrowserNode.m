//
//  STBrowserNode.m
//  SourcetreeBrowser
//
//  Created by dacaiguoguo on 2020/8/20.
//  Copyright © 2020 dacaiguoguo. All rights reserved.
//

#import "STBrowserNode.h"

@implementation NSString (deleteLast)

- (NSString *)stringByPathClean {
    if ([self hasSuffix:@"/"]) {
        return [self substringToIndex:self.length - 1];
    }
    return self;
}

@end

@implementation STBrowserNode

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [[[self class] alloc] init];
    if (self) {
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.repositoryType = [aDecoder decodeObjectForKey:@"repositoryType"];
        self.isLeaf = [aDecoder decodeObjectForKey:@"isLeaf"];
        self.children = [aDecoder decodeObjectForKey:@"children"];
        // self.parent = [aDecoder decodeObjectForKey:@"parent"];
        // self.hashValue = [aDecoder decodeObjectForKey:@"hashValue"];
    }
    return self;
}

- (NSString *)cleanPath {
    return self.path.stringByPathClean;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:NSStringFromSelector(@selector(name))];
    [coder encodeObject:self.path forKey:NSStringFromSelector(@selector(path))];
    [coder encodeObject:self.repositoryType forKey:NSStringFromSelector(@selector(repositoryType))];
    [coder encodeObject:self.isLeaf forKey:NSStringFromSelector(@selector(isLeaf))];
    [coder encodeObject:self.children forKey:NSStringFromSelector(@selector(children))];
}

- (NSUInteger)hash {
    return self.cleanPath.hash;
}

- (BOOL)isEqual:(STBrowserNode *)object {
    BOOL ret = [self.cleanPath isEqualToString:object.cleanPath];
    return ret;
}

@end
