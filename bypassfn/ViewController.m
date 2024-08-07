//
//  ViewController.m
//  bypassfn
//
//  Created by dunkeyyfong on 03/08/2024.
//

#import "ViewController.h"
#include <stdio.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *runCommandButton; // IBOutlet for UIButton
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Additional setup if needed
}

- (IBAction)runCommandButtonTapped:(id)sender {
    [self runCommand:@"whoiam"];
}

- (void)runCommand:(NSString *)command {
    const char *cmd = [command UTF8String];
    FILE *pipe = popen(cmd, "r");
    if (pipe == NULL) {
        NSLog(@"Error opening pipe");
        return;
    }

    char buffer[128];
    NSMutableString *output = [NSMutableString string];
    while (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        [output appendString:[NSString stringWithUTF8String:buffer]];
    }

    int status = pclose(pipe);
    if (status == -1) {
        NSLog(@"Error closing pipe");
    } else {
        NSLog(@"Command exit status: %d", WEXITSTATUS(status));
    }

    // Display the output on the UILabel
    self.outputTextView.text = output;
}

@end

