//
//  PeepOpen.m
//  PeepOpen
//
//  Created by Pieter Noordhuis on 6/2/10.
//

#import "PeepOpen.h"

@implementation PeepOpen
static PeepOpen *po;
+ (id)sharedInstance
{
	return po;
}

- (id)initWithPlugInController:(id <TMPlugInController>)controller
{
	self = [self init];
	po = self;
	return self;
}

@end

@interface OakProjectController (PeepOpen) @end
@implementation OakProjectController (PeepOpen)
- (void)goToFile:(id)sender
{
	NSString *projectDir;
  OakProjectController *project = NULL;

  // First try to find a window with a project and get the projectDirectory
  // from it.
  for (NSWindow *w in [[NSApplication sharedApplication] orderedWindows]) {
    if ([[[w windowController] className] isEqualToString: @"OakProjectController"] &&
				[[w windowController] projectDirectory]) {
      project = [w windowController];
      break;
    }
  }

  if (project != NULL) {
    projectDir =  [project projectDirectory];
  } 
  else if ([[currentDocument valueForKey:@"filename"] length] > 0) {
		projectDir = [currentDocument valueForKey:@"filename"];
  }
  
	NSString *projectURLString = [NSString stringWithFormat:@"peepopen://%@?editor=TextMate", projectDir];
	NSURL *url = [NSURL URLWithString:projectURLString];
	NSLog(@"PeepOpen: Opening URL %@", [url absoluteString]);
	[[NSWorkspace sharedWorkspace] openURL:url];
}
@end
