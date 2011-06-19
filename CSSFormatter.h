//
//  CSSFormatter.h
//  BeautifyTools
//
//  Created by supudo on 6/19/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSFormatter : NSObject {
}

- (NSString *)formatCSS1line:(NSString *)rawCSS;
- (NSString *)formatCSSMultiline:(NSString *)rawCSS;

@end
