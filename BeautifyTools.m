//
//  BeautifyTools.m
//  BeautifyTools
//
//  Created by supudo on 6/17/11.
//  Copyright (c) 2011 supudo.net, All Rights Reserved.
//

#import "BeautifyTools.h"
#import "CSSFormatter.h"

@implementation BeautifyTools

#pragma mark -
#pragma mark System specific

- (id) initWithPlugInController:(CodaPlugInsController *)inController bundle:(NSBundle *)yourBundle {
	if ((self = [super init]) != nil) {
		[NSBundle loadNibNamed:@"About" owner:self];
		controller = inController;
		[controller registerActionWithTitle:NSLocalizedString(@"CSS Format 1-line-elements", @"CSS Format 1-line-elements") target:self selector:@selector(cssFormat1Line:)];
		[controller registerActionWithTitle:NSLocalizedString(@"CSS Format Multiline", @"CSS Format Multiline") target:self selector:@selector(cssFormatMultiline:)];
		[controller registerActionWithTitle:NSLocalizedString(@"About", @"About") target:self selector:@selector(showAbout:)];
	}
	return self;
}

- (NSString *)name {
	return @"Beautify Tools";
}

#pragma mark -
#pragma mark Menu actions

- (void)cssFormat1Line:(id)sender {
	CodaTextView *tv = [controller focusedTextView:self];
	if (tv) {
		NSString *cssData = [tv string];
		if (![cssData isEqualToString:@""]) {
			NSRange wholeRange = NSMakeRange(0, [cssData length]);
			CSSFormatter *formatter = [[CSSFormatter alloc] init];
			NSString *formatedCSS = [formatter formatCSS1line:cssData];
			[formatter release];
			[tv replaceCharactersInRange:wholeRange withString:formatedCSS];
		}
	}
}

- (void)cssFormatMultiline:(id)sender {
	CodaTextView *tv = [controller focusedTextView:self];
	if (tv) {
		NSString *cssData = [tv string];
		if (![cssData isEqualToString:@""]) {
			NSRange wholeRange = NSMakeRange(0, [cssData length]);
			CSSFormatter *formatter = [[CSSFormatter alloc] init];
			NSString *formatedCSS = [formatter formatCSSMultiline:cssData];
			[formatter release];
			[tv replaceCharactersInRange:wholeRange withString:formatedCSS];
		}
	}
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

#pragma mark -
#pragma mark Actions

- (IBAction)openURL:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://github.com/supudo/CodaBeautifyTools"]];
}

- (IBAction)closeAbout:(id)sender {
	[dialogAbout close];
}

@end
