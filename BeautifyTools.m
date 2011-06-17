//
//  BeautifyTools.m
//  BeautifyTools
//
//  Created by supudo on 6/17/11.
//  Copyright (c) 2011 supudo.net, All Rights Reserved.
//

#import "BeautifyTools.h"

@interface BeautifyTools (Hidden)

- (NSString *)formatCSS:(NSString *)rawCSS;

@end

@implementation BeautifyTools

#pragma mark -
#pragma mark System specific

- (id) initWithPlugInController:(CodaPlugInsController *)inController bundle:(NSBundle *)yourBundle {
	if ((self = [super init]) != nil) {
		[NSBundle loadNibNamed:@"About" owner:self];

		controller = inController;
		[controller registerActionWithTitle:NSLocalizedString(@"Format", @"Format")
					  underSubmenuWithTitle:NSLocalizedString(@"CSS", @"CSS") target:self selector:@selector(cssFormat:)
						  representedObject:nil keyEquivalent:@"" pluginName:NSLocalizedString(@"MainTitle", @"MainTitle")];
		[controller registerActionWithTitle:NSLocalizedString(@"About", @"About") target:self selector:@selector(showAbout:)];
	}
	return self;
}

- (NSString *)name {
	return @"Beautify Tools";
}

#pragma mark -
#pragma mark Menu actions

- (void)cssFormat:(id)sender {
	CodaTextView *tv = [controller focusedTextView:self];
	if (tv) {
		NSString *cssData = [tv string];
		if (![cssData isEqualToString:@""]) {
			NSRange wholeRange = NSMakeRange(0, [cssData length]);
			NSString *formatedCSS = [self formatCSS:cssData];
			[tv replaceCharactersInRange:wholeRange withString:formatedCSS];
		}
	}
	
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText:[NSString stringWithFormat:@"Done", [self name]]];
	[alert setInformativeText:@"The code was formatted successfully!"];
	[alert setAlertStyle:NSCriticalAlertStyle];
	[alert runModal];
}

#pragma mark -
#pragma mark Workers

- (NSString *)formatCSS:(NSString *)rawCSS {
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
	
	return [NSString stringWithFormat:@"/* Formatted by CSS Formater */\n\n%@", formattedCSS];
}

#pragma mark -
#pragma mark Dialogs

- (void)showAbout:(id)sender {
	CodaTextView *textView = [controller focusedTextView:self];
	NSWindow *window = [textView window];

	[dialogAbout makeFirstResponder:btnClose];
	
	if (window && ![window attachedSheet])
		[NSApp beginSheet:dialogAbout modalForWindow:window modalDelegate:self didEndSelector:nil contextInfo:nil];
	else
		NSBeep();
}

- (IBAction)openURL:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://github.com/supudo/CodaBeautifyTools"]];
}

- (IBAction)closeAbout:(id)sender {
	[dialogAbout close];
}

@end
