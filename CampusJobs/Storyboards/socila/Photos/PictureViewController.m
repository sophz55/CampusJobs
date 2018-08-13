//
//  ViewController.m
//  ViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//
/*
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    [self.imageview setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)imagePickerControllerDidCancel:(nonnull UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)Facebook:(id)sender {
    
    composer = [[SLComposeViewController alloc] init];
    composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [composer setInitialText:[NSString stringWithFormat:@"%@",self.textfield.text]];
    [composer addImage:self.imageview.image];
    [self presentViewController:composer animated:YES completion:NULL];
    
    
}

- (IBAction)Twitter:(id)sender {
    
    composer = [[SLComposeViewController alloc] init];
    composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composer setInitialText:[NSString stringWithFormat:@"%@",self.textfield.text]];
    [composer addImage:self.imageview.image];
    [self presentViewController:composer animated:YES completion:NULL];
}

- (IBAction)DismissKeyboard:(id)sender {
    
    [self resignFirstResponder];
}

















@end
*/
