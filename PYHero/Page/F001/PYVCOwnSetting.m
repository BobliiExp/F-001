//
//  PYVCOwnSetting.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCOwnSetting.h"

@interface PYVCOwnSetting ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UIImageView *imgV; ///< 头像
@property (nonatomic, weak) UILabel *labNick; ///< 昵称

@end

@implementation PYVCOwnSetting

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    self.title = KLocalizable(@"setting");
    self.view.backgroundColor = kColor_Background;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:KLocalizable(@"save") style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemOnClicked:)];
    item.tintColor = kColor_Title;
    self.navigationItem.rightBarButtonItem = item;
    
    NSArray *arr = [PYUserManage py_getUserInfo];
    
    CGFloat bottomNav = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(bottomNav + 20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@101);
    }];
    
    CGFloat height = 60;
    CGFloat space = 12.f;
    UILabel *lab = [[UILabel alloc] init];
    lab.font = kFont_XL;
    lab.textColor = kColor_Title;
    lab.text = KLocalizable(@"avatar");
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(space);
        make.top.equalTo(@20);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = arr.firstObject;
    [view addSubview:imgV];
    self.imgV = imgV;
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-space);
        make.width.height.equalTo(@(height-10));
        make.centerY.equalTo(lab);
    }];
    
    imgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVOnClicked:)];
    [imgV addGestureRecognizer:tapImg];
    
    CALayer *line = [[CALayer alloc] init];
    line.backgroundColor = kColor_Background.CGColor;
    line.frame = CGRectMake(space, height+1, kScreenWidth - space, 1.f);
    [view.layer addSublayer:line];
    
    height = 40.f;
    UILabel *labName = [[UILabel alloc] init];
    labName.font = lab.font;
    labName.textColor = lab.textColor;
    labName.text = KLocalizable(@"nickname");
    [view addSubview:labName];
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.equalTo(lab);
        make.top.equalTo(@(61+10));
    }];
    
    UILabel *labNick = [[UILabel alloc] init];
    labNick.font = kFont_XL;
    labNick.textColor = kColor_Title;
    labNick.text = arr.lastObject;
    labNick.textAlignment = NSTextAlignmentRight;
    [view addSubview:labNick];
    self.labNick = labNick;
    [labNick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgV);
        make.centerY.equalTo(labName);
        make.height.equalTo(@30);
        make.width.equalTo(@220);
    }];
    
    labNick.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labOnClicked:)];
    [labNick addGestureRecognizer:tap];
}

#pragma mark - 点击事件

- (void)rightBarButtonItemOnClicked:(UIBarButtonItem *)item {
    NSArray *arr = @[self.imgV.image,self.labNick.text];
    [PYUserManage py_saveUsrInfo:arr];
    
    if (self.block) {
        self.block();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)labOnClicked:(UITapGestureRecognizer *)tap {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"请输入昵称" delegate:self cancelButtonTitle:KLocalizable(@"cancel") otherButtonTitles:KLocalizable(@"determine"), nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)imgVOnClicked:(UITapGestureRecognizer *)tap {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *txtV = [alertView textFieldAtIndex:0];
        self.labNick.text = txtV.text;
    }
}

#pragma mark - UIImagePickerControllerDelegate Call Back Implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    __weak typeof(self) weakSelf = self;
    
    if ([type isEqualToString:@"public.image"]){
        NSString *key = nil;
        
        if (picker.allowsEditing){
            key = UIImagePickerControllerEditedImage;
        }else{
            key = UIImagePickerControllerOriginalImage;
        }
        
        UIImage * image = [info objectForKey:key];
        weakSelf.imgV.image = image;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
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

@end
