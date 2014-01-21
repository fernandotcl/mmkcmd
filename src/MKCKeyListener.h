/*
 * This file is part of mmkcmd.
 *
 * © 2014 Fernando Tarlá Cardoso Lemos
 *
 * Refer to the LICENSE file for licensing information.
 *
 */

@import Foundation;

@interface MKCKeyListener : NSObject

@property (nonatomic, copy) NSString *playPauseCommand;
@property (nonatomic, copy) NSString *fastForwardCommand;
@property (nonatomic, copy) NSString *rewindCommand;

- (void)startListening;
- (void)stopListening;

@end
