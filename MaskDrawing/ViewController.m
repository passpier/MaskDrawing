//
//  ViewController.m
//  MaskDrawing
//
//  Created by Vincent Cheng on 2018/1/9.
//  Copyright © 2018年 Vincent Cheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, ColorMaskViewModelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentMaskLabel;
@property (weak, nonatomic) IBOutlet UIView *snapshotView;
@property (weak, nonatomic) IBOutlet UITableView *maskTableView;
@property (strong, nonatomic) ColorMaskViewModel *colorMaskViewModel;

@end

static const int snapshotViewTag = 1;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.snapshotView.userInteractionEnabled = YES;
    self.snapshotView.tag = snapshotViewTag;
    self.colorMaskViewModel = [[ColorMaskViewModel alloc] initWithColorView:_snapshotView];
    self.colorMaskViewModel.delegate = self;
    
    self.maskTableView.delegate = self;
    self.maskTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewMask:(id)sender {
    self.colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeAdd;
}

- (IBAction)moveMask:(id)sender {
    self.colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeChangePosition;
}

- (IBAction)resizeMask:(id)sender {
    self.colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeResizing;
}

- (IBAction)completeEditMask:(id)sender {
    self.colorMaskViewModel.colorMaskViewEditMode = ColorMaskViewEditModeDone;
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // We are starting to draw
    // Get the current touch.
    UITouch *touch = [touches anyObject];
    if (touch.view.tag != snapshotViewTag) {
        return;
    }
    
    [self.colorMaskViewModel colorViewTouchesBegan:[touch locationInView:_snapshotView]];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
    if (touch.view.tag != snapshotViewTag) {
        return;
    }
    
    [self.colorMaskViewModel colorViewTouchesMoved:[touch locationInView:_snapshotView]];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
    if (touch.view.tag != snapshotViewTag) {
        return;
    }
    
    [self.colorMaskViewModel colorViewTouchesEnded:[touch locationInView:_snapshotView]];
}

#pragma mark - ColorMaskViewModelDelegate methods

- (void)createNewColorMaskViewCompletion {
    [self.maskTableView reloadData];
}

#pragma mark - Device orientation methods

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_colorMaskViewModel.colorMaskList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Mask %ld", [indexPath row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.colorMaskViewModel selectColorMaskByIndex:[indexPath row]];
}

#pragma mark - UITableViewDelegate methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.colorMaskViewModel removeColorMaskByIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %ld", editingStyle);
    }
}

@end
