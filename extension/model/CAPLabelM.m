//
//  LabelM.m
//  EOSClient2
//
//  Created by Chang Sam on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPLabelM.h"

@implementation CAPLabelM

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fontSize = NAN;
        _charSpace = NAN;
        _lineSpace = NAN;
    }
    return self;
}

-(void)mergeFromDic:(NSDictionary *)dic{
    [super mergeFromDic: dic];
    
    if ([dic valueForKey: @"text"]) {
        self.text = [[dic valueForKey: @"text"] description];
    }else{
        self.text = @"";
    }
    if ([dic valueForKey: @"html"]) {
        self.html = [[dic valueForKey: @"html"] boolValue];
    }
    if ([dic valueForKey: @"fontName"]) {
        self.fontName = [dic valueForKey: @"fontName"];
    }
    if ([dic valueForKey: @"fontSize"]) {
        self.fontSize = [[dic valueForKey: @"fontSize"] floatValue];
    }
    if ([dic valueForKey: @"color"]) {
        self.color = [dic valueForKey: @"color"];
    }
    if ([dic valueForKey: @"bold"]) {
        self.bold = [[dic valueForKey: @"bold"] boolValue];
    }
    if ([dic valueForKey: @"align"]) {
        self.align = [dic valueForKey: @"align"];
    }
    if ([dic valueForKey: @"verticalAlign"]) {
        self.verticalAlign = [dic valueForKey: @"verticalAlign"];
    }
    if ([dic valueForKey: @"maxLines"]) {
        self.maxLines = [[dic valueForKey: @"maxLines"] intValue];
    }
    if ([dic valueForKey: @"wrap"]) {
        self.wrap = [[dic valueForKey: @"wrap"] boolValue];
    }
    if ([dic valueForKey: @"charSpace"]) {
        self.charSpace = [[dic valueForKey: @"charSpace"] floatValue];
    }
    if ([dic valueForKey: @"lineSpace"]) {
        self.lineSpace = [[dic valueForKey: @"lineSpace"] floatValue];
    }
}

-(void)fillSelfDic:(NSMutableDictionary *)dic{
    [super fillSelfDic: dic];
    
    if (_text) {
        NSString *str = [_text description];
        str = [str stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"];
        str = [str stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
        str = [str stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"];
        
        [dic setValue: str forKey: @"text"];
    }
    if (_html) {
        [dic setValue: [NSNumber numberWithBool: _html] forKey: @"html"];
    }
    if (_fontName) {
        [dic setValue: _fontName forKey: @"fontName"];
    }
    if (_fontSize && !isnan(_fontSize)) {
        [dic setValue: [NSNumber numberWithFloat: _fontSize] forKey: @"fontSize"];
    }
    if (_color) {
        [dic setValue: _color forKey: @"color"];
    }
    if (_bold) {
        [dic setValue: [NSNumber numberWithBool: _bold] forKey: @"bold"];
    }
    if (_align) {
        [dic setValue: _align forKey: @"align"];
    }
    if (_verticalAlign) {
        [dic setValue: _verticalAlign forKey: @"verticalAlign"];
    }
    if (_maxLines) {
        [dic setValue: [NSNumber numberWithInteger: _maxLines] forKey: @"maxLines"];
    }
    if (_wrap) {
        [dic setValue: [NSNumber numberWithBool: _wrap] forKey: @"wrap"];
    }
    if (_lineSpace && !isnan(_lineSpace)) {
        [dic setValue: [NSNumber numberWithFloat: _lineSpace] forKey: @"lineSpace"];
    }
    if (_charSpace && !isnan(_charSpace)) {
        [dic setValue: [NSNumber numberWithFloat: _charSpace] forKey: @"charSpace"];
    }

}

-(id)copyWithZone:(NSZone *)zone{
    CAPLabelM *m = [super copyWithZone: zone];
    m.text = _text;
    m.html = _html;
    m.fontName = _fontName;
    m.fontSize = _fontSize;
    m.color = _color;
    m.bold = _bold;
    m.align = _align;
    m.verticalAlign = _verticalAlign;
    m.maxLines = _maxLines;
    m.wrap = _wrap;
    m.charSpace = _charSpace;
    m.lineSpace = _lineSpace;
    
    return m;
}

@end
