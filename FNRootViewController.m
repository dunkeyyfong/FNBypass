#import "FNRootViewController.h"
#import <UIKit/UIKit.h>

@interface FNRootViewController ()

@property (nonatomic, strong) UILabel *outputLabel;
	
@end

@implementation FNRootViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	UIButton *runCommandButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[runCommandButton setTitle:@"Run Command" forState:UIControlStateNormal];
	runCommandButton.frame = CGRectMake(100, 100, 200, 50);
	[runCommandButton addTarget:self action:@selector(runCommandButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:runCommandButton];

	self.outputLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 300)];
	self.outputLabel.numberOfLines = 0;
	self.outputLabel.backgroundColor = [UIColor lightGrayColor];
	[self.view addSubview:self.outputLabel];
}

- (void)runCommandButtonTapped:(id)sender {
	[self runCommand:@"ls -l"];
}

- (void)runCommand:(NSString *)command {
	const char *cmd = [command UTF8String];
	FILE *pipe = popen(cmd, "r");
	if (pipe == NULL){
		NSLog(@"Error opening pipe");
		return;
	}

	char buffer[128];
	NSMutableString *output = [NSMutableString string];
	while (fgets(buffer, sizeof(buffer), pipe) != NULL) {
		[output appendString:[NSString stringWithUTF8String:buffer]];

	}

	pclose(pipe);

	self.outputLabel.text = output;
}

@end