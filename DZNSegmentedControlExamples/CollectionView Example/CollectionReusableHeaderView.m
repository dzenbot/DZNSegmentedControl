//
//  CollectionReusableHeaderView.m
//  CollectionView-Example
//
//  Created by Ignacio Romero Z. on 8/11/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "CollectionReusableHeaderView.h"

@interface CollectionReusableHeaderView ()
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation CollectionReusableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self addSubview:self.backgroundView];
    [self addSubview:self.titleLabel];
    
    NSDictionary *views = @{@"label": self.titleLabel};
    NSDictionary *metrics = @{@"leftPadding": @(10)};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftPadding-[label]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:metrics views:views]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHeaderView:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    }
    return _backgroundView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

+ (CGFloat)height
{
    return 38.0;
}

- (void)didTapHeaderView:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionReusableHeaderView:didTapHeader:)]) {
        [self.delegate collectionReusableHeaderView:self didTapHeader:sender];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _titleLabel.text = nil;
}

@end
