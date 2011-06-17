//
//  BeautifyTools.h
//  BeautifyTools
//
//  Created by supudo on 6/17/11.
//  Copyright (c) 2011 supudo.net, All Rights Reserved.
//

#import <Cocoa/Cocoa.h>
#import "CodaPlugInsController.h"

@class CodaPlugInsController;

@interface BeautifyTools : NSObject <CodaPlugIn> {
	CodaPlugInsController *controller;
	IBOutlet NSWindow *dialogAbout, *dialogSettings;
	IBOutlet NSTextField *txtSite;
	IBOutlet NSButton *btnClose;
}

- (id) initWithPlugInController:(CodaPlugInsController *)inController bundle:(NSBundle *)yourBundle;
- (IBAction)openURL:(id)sender;
- (IBAction)closeAbout:(id)sender;

@end
