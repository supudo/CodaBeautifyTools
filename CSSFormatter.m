//
//  CSSFormatter.m
//  BeautifyTools
//
//  Created by supudo on 6/19/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import "CSSFormatter.h"

@implementation CSSFormatter

- (NSString *)formatCSS1line:(NSString *)rawCSS {
	rawCSS = [rawCSS stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	rawCSS = [rawCSS stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	rawCSS = [rawCSS stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
	rawCSS = [rawCSS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	rawCSS = [rawCSS stringByReplacingOccurrencesOfString:@"}" withString:@"}\n"];
	
	NSString *formattedCSS = @"";
	NSArray *lines = [rawCSS componentsSeparatedByString:@"\n"];
	
	NSString *currentLine;
	BOOL inComment;
	NSRange rangeComment;
	for (int i=0; i<[lines count]; i++) {
		currentLine = [lines objectAtIndex:i];
		
		if (![[currentLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
			rangeComment = [currentLine rangeOfString:@"/*"];
			if (rangeComment.location != NSNotFound)
				inComment = TRUE;
			
			rangeComment = [currentLine rangeOfString:@"*/"];
			if (rangeComment.location == NSNotFound)
				inComment = FALSE;
			
			currentLine = [currentLine stringByReplacingOccurrencesOfString:@"\t" withString:@""];
			currentLine = [currentLine stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			if (!inComment) {
				NSArray *lineArr = [currentLine componentsSeparatedByString:@"{"];
				NSString *key;
				if ([lineArr count] > 0 && [lineArr objectAtIndex:0] != nil)
					key = [[lineArr objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				NSString *val;
				if ([lineArr count] > 1 && [lineArr objectAtIndex:1] != nil)
					val = [[lineArr objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				currentLine = [NSString stringWithFormat:@"%@ { %@", key, val];
				currentLine = [currentLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				currentLine = [currentLine stringByReplacingOccurrencesOfString:@":" withString:@": "];
				currentLine = [currentLine stringByReplacingOccurrencesOfString:@";" withString:@"; "];
				currentLine = [currentLine stringByReplacingOccurrencesOfString:@"{" withString:@" { "];
				currentLine = [currentLine stringByReplacingOccurrencesOfString:@"/*" withString:@"\n\n/* "];
				currentLine = [currentLine stringByReplacingOccurrencesOfString:@"*/" withString:@" */\n"];
				currentLine = [currentLine stringByReplacingOccurrencesOfString:@"  " withString:@" "];
				
				formattedCSS = [NSString stringWithFormat:@"%@\n%@", formattedCSS, currentLine];
			}
			else {
				currentLine = [currentLine stringByReplacingOccurrencesOfString:@"/*" withString:@"\n\n/* "];
				currentLine = [currentLine stringByReplacingOccurrencesOfString:@"*/" withString:@" */\n"];
				formattedCSS = [NSString stringWithFormat:@"%@%@", formattedCSS, currentLine];
			}
		}
	}
	
	return formattedCSS;
}

- (NSString *)formatCSSMultiline:(NSString *)rawCSS {
	NSString *formattedCSS = rawCSS;
	formattedCSS = [formattedCSS stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	formattedCSS = [formattedCSS stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	formattedCSS = [formattedCSS stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
	formattedCSS = [formattedCSS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	formattedCSS = [formattedCSS stringByReplacingOccurrencesOfString:@"/*" withString:@"\n/* "];
	formattedCSS = [formattedCSS stringByReplacingOccurrencesOfString:@"*/" withString:@" */\n"];
	formattedCSS = [formattedCSS stringByReplacingOccurrencesOfString:@"{" withString:@"{\n"];
	formattedCSS = [formattedCSS stringByReplacingOccurrencesOfString:@"}" withString:@"}\n\n"];
	formattedCSS = [formattedCSS stringByReplacingOccurrencesOfString:@";" withString:@";\n"];

	NSString *css = @"";
	NSArray *lines = [formattedCSS componentsSeparatedByString:@"\n"];
	NSString *currentLine;
	NSRange rng;
	for (int i=0; i<[lines count]; i++) {
		currentLine = [lines objectAtIndex:i];
		rng = [currentLine rangeOfString:@";"];
		if (rng.location != NSNotFound)
			currentLine = [NSString stringWithFormat:@"  %@", currentLine];
		css = [NSString stringWithFormat:@"%@\n%@", css, currentLine];
	}

	return css;
}

@end
