//
//  RecordDetailViewController.m
//  Arduino
//
//  Created by Rodrigo Cavalcante on 12/30/15.
//  Copyright © 2015 Rodrigo Cavalcante. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "SSSnackbar.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface RecordDetailViewController ()

@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.record == nil)
        [self dismissViewControllerAnimated:YES completion:^{
            [[SSSnackbar snackbarWithMessage:@"Não foi possível abrir os detalhes." actionText:nil duration:3 actionBlock:nil dismissalBlock:nil] show];
        }];
    else {
        self.detailTitle.text = [NSString stringWithFormat:@"Em: %@",[self.record formatedCreatedAt]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[self.record objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"]]];
        
        [self.imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"info"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            self.imageView.image = image;
            self.scrollView.contentSize = self.imageView.image.size;
            self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            [[SSSnackbar snackbarWithMessage:@"Não foi possível carregar a imagem." actionText:nil duration:3 actionBlock:nil dismissalBlock:nil] show];
        }];
    }
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
