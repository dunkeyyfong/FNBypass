#import "FNRootViewController.h"
#include <sys/types.h>
#include <sys/wait.h>
#include <spawn.h>
#include <unistd.h>
#include <fcntl.h>

@implementation FNRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Tạo UIButton
    UIButton *runCommandButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [runCommandButton setTitle:@"Run Command" forState:UIControlStateNormal];
    runCommandButton.frame = CGRectMake(100, 100, 200, 50);
    [runCommandButton addTarget:self action:@selector(runCommandButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:runCommandButton];
    
    // Tạo UILabel
    self.outputLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 400)];
    self.outputLabel.numberOfLines = 0;
    self.outputLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.outputLabel];
}

- (void)runCommandButtonTapped:(id)sender {
    [self runCommand:@"ls -l"];
}

- (void)runCommand:(NSString *)command {
    pid_t pid;
    int status;
    
    // Thiết lập ống dẫn đầu ra
    int pipefds[2];
    if (pipe(pipefds) < 0) {
        self.outputLabel.text = @"Error creating pipe";
        return;
    }
    
    char *argv[] = { "/bin/zsh", "-c", (char *)[command UTF8String], NULL };
    if (posix_spawn(&pid, "/bin/zsh", NULL, NULL, argv, NULL) != 0) {
        // Lấy và in ra mã lỗi
        char errorMessage[256];
        strerror_r(errno, errorMessage, sizeof(errorMessage));
        self.outputLabel.text = [NSString stringWithFormat:@"Error spawning process: %s", errorMessage];
        return;
    }
    
    // Đọc kết quả từ ống dẫn
    close(pipefds[1]);  // Đóng đầu ghi của ống dẫn
    char buffer[256];
    ssize_t bytesRead;
    NSMutableString *output = [NSMutableString string];
    while ((bytesRead = read(pipefds[0], buffer, sizeof(buffer))) > 0) {
        [output appendString:[[NSString alloc] initWithBytes:buffer length:bytesRead encoding:NSUTF8StringEncoding]];
    }
    close(pipefds[0]);  // Đóng đầu đọc của ống dẫn
    
    // Cập nhật UILabel
    self.outputLabel.text = output;
    
    waitpid(pid, &status, 0);
}

@end
