//
//  ListM.m
//  EOSClient2
//
//  Created by Chang Sam on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPListM.h"

@implementation CAPListM

-(void)mergeFromDic:(NSDictionary *)dic{
    [super mergeFromDic: dic];
    
    NSDictionary *template = [dic valueForKey: @"template"];
    if (template) {
        if ([template valueForKey: @"groupBy"]) {
            self.groupBy = [template valueForKey: @"groupBy"];
        }
        if ([template valueForKey: @"header"]) {
            self.header = [ModelBuilder buildModel: [template valueForKey: @"header"]];
        }
        if ([template valueForKey: @"body"]) {
            self.body = [ModelBuilder buildModel: [template valueForKey: @"body"]];
        }
        if ([template valueForKey: @"footer"]) {
            self.footer = [ModelBuilder buildModel: [template valueForKey: @"footer"]];
        }
        if ([template valueForKey: @"sectionHeader"]) {
            self.sectionHeader = [ModelBuilder buildModel: [template valueForKey: @"sectionHeader"]];
        }
        if ([template valueForKey: @"sectionFooter"]) {
            self.sectionFooter = [ModelBuilder buildModel: [template valueForKey: @"sectionFooter"]];
        }
        if ([template valueForKey: @"indexable"]) {
            self.indexable = [[template valueForKey: @"indexable"] boolValue];
        }
    }
    
    if ([dic valueForKey: @"__row_height"]) {
        self.__row_height = [dic valueForKey: @"__row_height"];
    }
    if ([dic valueForKey: @"__row_count"]) {
        self.__row_count = [dic valueForKey: @"__row_count"];
    }
    if ([dic valueForKey: @"__row_data"]) {
        self.__row_data = [dic valueForKey: @"__row_data"];
    }
    if ([dic valueForKey: @"__section_count"]) {
        self.__section_count = [dic valueForKey: @"__section_count"];
    }
    if ([dic valueForKey: @"__section_footer_data"]) {
        self.__section_footer_data = [dic valueForKey: @"__section_footer_data"];
    }
    if ([dic valueForKey: @"__section_footer_height"]) {
        self.__section_footer_height = [dic valueForKey: @"__section_footer_height"];
    }
    if ([dic valueForKey: @"__section_footer_layout"]) {
        self.__section_footer_layout = [dic valueForKey: @"__section_footer_layout"];
    }
    if ([dic valueForKey: @"__section_header_data"]) {
        self.__section_header_data = [dic valueForKey: @"__section_header_data"];
    }
    if ([dic valueForKey: @"__section_header_height"]) {
        self.__section_header_height = [dic valueForKey: @"__section_header_height"];
    }
    if ([dic valueForKey: @"__section_header_layout"]) {
        self.__section_header_layout = [dic valueForKey: @"__section_header_layout"];
    }
    if ([dic valueForKey: @"__index_titles"]) {
        self.__index_titles = [dic valueForKey: @"__index_titles"];
    }
    if ([dic valueForKey: @"onselected"]) {
        self.onselected = [dic valueForKey: @"onselected"];
    }
    if ([dic valueForKey: @"__title_index"]) {
        self.__title_index = [dic valueForKey: @"__title_index"];
    }
    if ([dic valueForKey: @"__row_layout"]) {
        self.__row_layout = [dic valueForKey: @"__row_layout"];
    }

    if ([dic valueForKey: @"dragDownLayout"]) {
        self.dragDownLayout = [ModelBuilder buildModel: [dic valueForKey: @"dragDownLayout"]];
    }
    if ([dic valueForKey: @"dragDownMinMovement"]) {
        self.dragDownMinMovement = [[dic valueForKey: @"dragDownMinMovement"] floatValue];
    }
    if ([dic valueForKey: @"onDragDownStateChanged"]) {
        self.onDragDownStateChanged = [dic valueForKey: @"onDragDownStateChanged"];
    }
    if ([dic valueForKey: @"onDragDownAction"]) {
        self.onDragDownAction = [dic valueForKey: @"onDragDownAction"];
    }
}

-(id)copyWithZone:(NSZone *)zone{
    CAPListM *m = [super copyWithZone: zone];
    m.header = [_header copy];
    m.body = [_body copy];
    m.footer = [_footer copy];
    m.sectionFooter = [_sectionFooter copy];
    m.sectionHeader = [_sectionHeader copy];
    m.groupBy = _groupBy;
    m.indexable = _indexable;
    
    m.__row_height = ___row_height;
    m.__row_count = ___row_count;
    m.__row_data = ___row_data;
    m.__row_layout = ___row_layout;
    
    m.__section_count = ___section_count;
    m.__section_footer_height = ___section_footer_height;
    m.__section_footer_data = ___section_footer_data;
    m.__section_header_height = ___section_header_height;
    m.__section_header_data = ___section_header_data;

    m.__section_footer_layout = ___section_footer_layout;
    m.__section_header_layout = ___section_header_layout;
    
    m.__index_titles = ___index_titles;
    m.__title_index = ___title_index;
    
    m.onselected = _onselected;

    m.onDragDownAction = _onDragDownAction;
    m.onDragDownStateChanged = _onDragDownStateChanged;
    m.dragDownLayout = [_dragDownLayout copy];
    m.dragDownMinMovement = _dragDownMinMovement;
    
    return m;
}

@end
