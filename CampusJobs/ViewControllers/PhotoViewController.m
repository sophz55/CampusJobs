//
//  PhotoViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/24/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)TakePhoto:(id)sender {
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)LoadLibrary:(id)sender {
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:NULL];
}
-(void)imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.ImageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)imagePickerControllerDidCancel:(nonnull UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}





- (IBAction)Facebook:(id)sender {
    composer = [[SLComposeViewController alloc] init];
    composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [composer setInitialText:[NSString stringWithFormat:@"%@",self.TextField.text]];
    [composer addImage:self.ImageView.image];
    [self presentViewController:composer animated:YES completion:NULL];
    
    
}

- (IBAction)Twitter:(id)sender {
    
    composer = [[SLComposeViewController alloc] init];
    composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composer setInitialText:[NSString stringWithFormat:@"%@",self.TextField.text]];
    [composer addImage:self.ImageView.image];
    [self presentViewController:composer animated:YES completion:NULL];
    
    
}

- (IBAction)DismissKeyboard:(id)sender {
    
    
    [self resignFirstResponder];
}
@end
