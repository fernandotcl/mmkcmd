/*
 * This file is part of mmkcmd.
 *
 * © 2014 Fernando Tarlá Cardoso Lemos
 *
 * Refer to the LICENSE file for licensing information.
 *
 */

#import <Foundation/Foundation.h>
#import <getopt.h>
#import <stdio.h>
#import <stdlib.h>

#import "MKCKeyListener.h"


static void print_usage(FILE *fp)
{
    fprintf(fp, "\
Usage: \n\
    " PROGRAM_NAME " [--fast-forward-command <command>] \
        [--play-pause-command <command>] [--rewind-command <command>]\n\
    " PROGRAM_NAME " --help\n");
}

static int autorelease_main(int argc, char **argv)
{
    struct option long_options[] = {
        {"fast-forward-command", required_argument, NULL, 'f'},
        {"help", no_argument, NULL, 'h'},
        {"play-pause-command", required_argument, NULL, 'p'},
        {"rewind-command", required_argument, NULL, 'r'}
    };
    const char *options = "f:hp:r:";

    MKCKeyListener *keyListener = [MKCKeyListener new];

    int opt;
    while ((opt = getopt_long(argc, argv, options, long_options, NULL)) != -1) {
        switch (opt) {
            case 'f':
                keyListener.fastForwardCommand = [NSString stringWithCString:optarg
                                                                    encoding:NSUTF8StringEncoding];
                break;
            case 'h':
                print_usage(stdout);
                return EXIT_SUCCESS;
            case 'p':
                keyListener.playPauseCommand = [NSString stringWithCString:optarg
                                                                  encoding:NSUTF8StringEncoding];
                break;
            case 'r':
                keyListener.rewindCommand = [NSString stringWithCString:optarg
                                                               encoding:NSUTF8StringEncoding];
                break;
            default:
                print_usage(stderr);
                return EXIT_FAILURE;
        }
    }

    [keyListener startListening];
    CFRunLoopRun();

    return EXIT_SUCCESS;
}

int main(int argc, char **argv)
{
    @autoreleasepool {
        return autorelease_main(argc, argv);
    }
}
