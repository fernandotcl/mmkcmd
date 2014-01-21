/*
 * This file is part of mmkcmd.
 *
 * © 2014 Fernando Tarlá Cardoso Lemos
 *
 * Refer to the LICENSE file for licensing information.
 *
 */

@import AppKit;

#import <IOKit/hidsystem/ev_keymap.h>
#import <paths.h>

#import "MKCKeyListener.h"


@interface MKCKeyListener ()

@property (nonatomic, assign) CFMachPortRef eventTap;
@property (nonatomic, assign) CFRunLoopSourceRef eventSource;

- (CGEventRef)_handleEvent:(CGEventRef)event withType:(CGEventType)type;

@end


static CGEventRef eventTapCallback(CGEventTapProxy proxy,
                                   CGEventType type,
                                   CGEventRef event,
                                   void *refcon)
{
    MKCKeyListener *listener = (__bridge MKCKeyListener *)refcon;
    return [listener _handleEvent:event withType:type];
}


@implementation MKCKeyListener

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.eventTap = CGEventTapCreate(kCGSessionEventTap,
                                         kCGHeadInsertEventTap,
                                         kCGEventTapOptionDefault,
                                         CGEventMaskBit(NX_SYSDEFINED),
                                         eventTapCallback,
                                         (__bridge void *)self);

        self.eventSource = CFMachPortCreateRunLoopSource(kCFAllocatorSystemDefault,
                                                         self.eventTap, 0);
    }
    return self;
}

- (void)dealloc
{
    if (self.eventSource != NULL) {
        CFRelease(self.eventSource);
        self.eventSource = NULL;
    }

    if (self.eventTap != NULL) {
        CFMachPortInvalidate(self.eventTap);
        CFRelease(self.eventTap);
        self.eventTap = NULL;
    }
}

- (void)startListening
{
    CFRunLoopAddSource(CFRunLoopGetCurrent(), self.eventSource, kCFRunLoopCommonModes);
}

- (void)stopListening
{
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), self.eventSource, kCFRunLoopCommonModes);
}

- (CGEventRef)_handleEvent:(CGEventRef)event withType:(CGEventType)type
{
    NSEvent *nsEvent = [NSEvent eventWithCGEvent:event];

    if (type != NX_SYSDEFINED || nsEvent.subtype != 8) {
        return event;
    }

    CGKeyCode keyCode = (nsEvent.data1 & 0xffff0000) >> 16;
    BOOL keyUp = !((nsEvent.data1 & 0x0000ff00) == 0x00000a00);

    switch (keyCode) {
        case NX_KEYTYPE_PLAY:
            if (keyUp) {
                [self _executeCommand:self.playPauseCommand];
            }
            return NULL;
        case NX_KEYTYPE_FAST:
            if (keyUp) {
                [self _executeCommand:self.fastForwardCommand];
            }
            return NULL;
        case NX_KEYTYPE_REWIND:
            if (keyUp) {
                [self _executeCommand:self.rewindCommand];
            }
            return NULL;
        default:
            return event;
    }
}

- (void)_executeCommand:(NSString *)command
{
    if (command == nil) return;

    NSTask *task = [NSTask new];

    task.launchPath = [NSString stringWithCString:_PATH_BSHELL
                                         encoding:NSUTF8StringEncoding];
    task.arguments = @[@"-c", command];

    NSFileHandle *devnull = [NSFileHandle fileHandleWithNullDevice];
    task.standardInput = devnull;
    task.standardOutput = devnull;
    task.standardError = devnull;

    [task launch];
    [task waitUntilExit];
}

@end
