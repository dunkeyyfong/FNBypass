//
//  ViewController.m
//  bypassfn
//
//  Created by dunkeyyfong on 03/08/2024.
//

#import "ViewController.h"
#include <stdio.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *runCommandButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *runCommandButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [runCommandButton setTitle:@"Run" forState:UIControlStateNormal];
    runCommandButton.frame = CGRectMake(100, 100, 200, 50);
    [runCommandButton addTarget:self action:@selector(runCommandButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:runCommandButton];     
    
}

- (IBAction)runCommandButtonTapped:(id)sender {
    [self runCommand:@"cd /; ls -l"];
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
    
    pclose(pipe);
    NSLog(@"Command output: %@", output);
}

@end
