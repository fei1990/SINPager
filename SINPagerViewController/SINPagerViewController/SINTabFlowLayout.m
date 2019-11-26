//
//  SINTabFlowLayout.m
//  SINPagerViewController
//
//  Created by wf on 2019/11/19.
//  Copyright © 2019 sohu. All rights reserved.
//

#import "SINTabFlowLayout.h"

@implementation SINTabFlowLayout

- (NSMutableDictionary *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableDictionary dictionary];
    }
    return _attributes;
}

-(void)prepareLayout {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumInteritemSpacing = 1;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray *attributes = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, self.collectionViewContentSize.width, self.collectionViewContentSize.height)];

    for (int i = 0; i < attributes.count; i ++) {
        UICollectionViewLayoutAttributes *attribute = attributes[i];
        if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
            NSString *indexStr = [NSString stringWithFormat:@"%d", i];
            self.attributes[indexStr] = attribute;
        }
    }

    return [attributes copy];
}

@end
