//
//  ViewController.m
//  TestCustomLayout
//
//  Created by Alexander on 13.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "TestLayout.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *dataArr;
    TestLayout *customLayout;
    UICollectionViewFlowLayout *flowLayout;
}
@property (nonatomic, weak) IBOutlet UICollectionView *collection;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArr = [NSMutableArray new];
    for (int i = 0; i < 8; i++) {
        NSMutableArray *sectionArr = [NSMutableArray new];
        for (int itemIdx = 0; itemIdx < 5; itemIdx++) {
            NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i * 5 + itemIdx + 1];
            [sectionArr addObject:imageName];
        }
        [dataArr addObject:sectionArr];
    }
    
    customLayout = [TestLayout new];
    customLayout.cellSize = CGSizeMake(100, 100);
    customLayout.sectionSpacing = CGSizeMake(20, 20);
    
    flowLayout = (id)self.collection.collectionViewLayout;
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [self.collection setCollectionViewLayout:flowLayout animated:YES];
    } else {
        [self.collection setCollectionViewLayout:customLayout animated:YES];
    }
}

#pragma mark - Collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [dataArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    UIImageView *imgView = (id)[cell viewWithTag:1];
    imgView.image = [UIImage imageNamed:dataArr[indexPath.section][indexPath.item]];
    cell.layer.zPosition = [collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath].zIndex;
    return cell;
}

@end
