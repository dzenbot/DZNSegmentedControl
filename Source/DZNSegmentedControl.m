//
//  DZNSegmentedControl.m
//  DZNSegmentedControl
//  https://github.com/dzenbot/DZNSegmentedControl
//
//  Created by Ignacio Romero Zurbuchen on 3/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "DZNSegmentedControl.h"

@interface DZNSegmentedControl ()
@property (nonatomic) BOOL initializing;
@property (nonatomic, strong) UIView *selectionIndicator;
@property (nonatomic, strong) UIView *hairline;
@property (nonatomic, strong) NSMutableDictionary *colors;
@property (nonatomic, getter = isTransitioning) BOOL transitioning;
@end

@implementation DZNSegmentedControl
@synthesize items = _items;
@synthesize selectedSegmentIndex = _selectedSegmentIndex;
@synthesize barPosition = _barPosition;

#pragma mark - Initialize Methods

- (void)initialize
{
    _initializing = YES;
    
    _selectedSegmentIndex = -1;
    _font = [UIFont systemFontOfSize:15.0];
    _height = 56.0;
    _selectionIndicatorHeight = 2.0;
    _animationDuration = 0.2;
    _showsCount = YES;
    _autoAdjustSelectionIndicatorWidth = YES;
    
    _selectionIndicator = [UIView new];
    _selectionIndicator.backgroundColor = self.tintColor;
    [self addSubview:_selectionIndicator];
    
    _hairline = [UIView new];
    _hairline.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_hairline];
    
    _colors = [NSMutableDictionary new];
    
    _initializing = NO;
}

- (id)init
{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        [self initialize];
        self.items = items;
    }
    return self;
}


#pragma mark - UIView Methods

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(self.superview.bounds.size.width, _height);
}

- (void)sizeToFit
{
    CGRect rect = self.frame;
    rect.size = [self sizeThatFits:rect.size];
    self.frame = rect;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self sizeToFit];
    
    if ([self buttons].count == 0) {
        _selectedSegmentIndex = -1;
    }
    else if (_selectedSegmentIndex < 0) {
        _selectedSegmentIndex = 0;
    }
    
    for (int i = 0; i < [self buttons].count; i++) {
        UIButton *button = [[self buttons] objectAtIndex:i];
        [button setFrame:CGRectMake(roundf(self.bounds.size.width/self.numberOfSegments)*i, 0, roundf(self.bounds.size.width/self.numberOfSegments), self.bounds.size.height)];
        
        CGFloat topInset = (_barPosition > UIBarPositionBottom) ? -4.0 : 4.0;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, topInset, 0)];
        
        if (i == _selectedSegmentIndex) {
            button.selected = YES;
        }
    }
    
    _selectionIndicator.frame = [self selectionIndicatorRect];
    _hairline.frame = [self hairlineRect];
    
    [self bringSubviewToFront:_selectionIndicator];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self layoutIfNeeded];
}

- (void)didMoveToWindow
{
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self configureSegments];
    
    [self layoutIfNeeded];
}


#pragma mark - Getter Methods

- (NSUInteger)numberOfSegments
{
    return _items.count;
}

- (NSArray *)buttons
{
    NSMutableArray *_buttons = [NSMutableArray new];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [_buttons addObject:view];
        }
    }
    return _buttons;
}

- (UIButton *)buttonAtIndex:(NSUInteger)segment
{
    if (_items.count > 0 && segment < [self buttons].count) {
        return (UIButton *)[[self buttons] objectAtIndex:segment];
    }
    return nil;
}

- (UIButton *)selectedButton
{
    if (_selectedSegmentIndex >= 0) {
        return [self buttonAtIndex:_selectedSegmentIndex];
    }
    return nil;
}

- (NSString *)stringForSegmentAtIndex:(NSUInteger)segment
{
    UIButton *button = [self buttonAtIndex:segment];
    return [[button attributedTitleForState:UIControlStateNormal] string];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment
{
    if (_showsCount) {
        NSString *title = [self stringForSegmentAtIndex:segment];
        NSArray *components = [title componentsSeparatedByString:@"\n"];
        
        if (components.count == 2) {
            return [components objectAtIndex:_inverseTitles ? 0 : 1];
        }
        else return nil;
    }
    return [_items objectAtIndex:segment];
}

- (NSNumber *)countForSegmentAtIndex:(NSUInteger)segment
{
    NSString *title = [self stringForSegmentAtIndex:segment];
    NSArray *components = [title componentsSeparatedByString:@"\n"];
    
    if (components.count == 2) {
        return @([[components objectAtIndex:_inverseTitles ? 1 : 0] intValue]);
    }
    else return @(0);
}

- (UIColor *)titleColorForState:(UIControlState)state
{
    NSString *key = [NSString stringWithFormat:@"UIControlState%d", (int)state];
    UIColor *color = [self.colors objectForKey:key];
    
    if (!color) {
        switch (state) {
            case UIControlStateNormal:              return [UIColor darkGrayColor];
            case UIControlStateHighlighted:         return self.tintColor;
            case UIControlStateDisabled:            return [UIColor lightGrayColor];
            case UIControlStateSelected:            return self.tintColor;
            default:                                return self.tintColor;
        }
    }
    
    return color;
}

- (CGRect)selectionIndicatorRect
{
    CGRect frame = CGRectZero;
    UIButton *button = [self selectedButton];
    NSString *title = [self titleForSegmentAtIndex:button.tag];
    
    if (title.length == 0) {
        return frame;
    }
    
    frame.origin.y = (_barPosition > UIBarPositionBottom) ? 0.0 : (button.frame.size.height-_selectionIndicatorHeight);
    
    if (_autoAdjustSelectionIndicatorWidth) {
        
        id attributes = nil;
        
        if (!_showsCount) {
            
            NSAttributedString *attributedString = [button attributedTitleForState:UIControlStateSelected];
            
            if (attributedString.string.length == 0) {
                return CGRectZero;
            }
            
            NSRangePointer range = nil;
            attributes = [attributedString attributesAtIndex:0 effectiveRange:range];
        }
        
        frame.size = CGSizeMake([title sizeWithAttributes:attributes].width, _selectionIndicatorHeight);
        frame.origin.x = (button.frame.size.width*(_selectedSegmentIndex))+(button.frame.size.width-frame.size.width)/2;
    }
    else {
        frame.size = CGSizeMake(button.frame.size.width, _selectionIndicatorHeight);
        frame.origin.x = (button.frame.size.width*(_selectedSegmentIndex));
    }
    
    return frame;
}

- (UIColor *)hairlineColor
{
    return _hairline.backgroundColor;
}

- (CGRect)hairlineRect
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    frame.origin.y = (_barPosition > UIBarPositionBottom) ? 0 : self.frame.size.height;
    
    return frame;
}


#pragma mark - Setter Methods

- (void)setTintColor:(UIColor *)color
{
    if (!color || !_items || _initializing) {
        return;
    }
    
    [super setTintColor:color];
    
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateSelected];
}

- (void)setItems:(NSArray *)items
{
    if (_items) {
        [self removeAllSegments];
    }
    
    if (items) {
        _items = [NSArray arrayWithArray:items];
        [self insertAllSegments];
    }
}

- (void)setDelegate:(id<DZNSegmentedControlDelegate>)delegate
{
    _delegate = delegate;
    _barPosition = [delegate positionForBar:self];
}

- (void)setSelectedSegmentIndex:(NSInteger)segment
{
    if (segment > self.numberOfSegments-1) {
        segment = 0;
    }
    
    [self setSelected:YES forSegmentAtIndex:segment];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    if (!title) {
        return;
    }
    
    NSAssert(segment < self.numberOfSegments, @"Cannot assign a title to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign a title to a negative segment.");
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    
    if (segment >= self.numberOfSegments) {
        [items insertObject:title atIndex:self.numberOfSegments];
        _items = items;
        
        [self addButtonForSegment:segment];
    }
    else {
        [items replaceObjectAtIndex:segment withObject:title];
        _items = items;
        
        [self setCount:[self countForSegmentAtIndex:segment] forSegmentAtIndex:segment];
    }
}

- (void)setCount:(NSNumber *)count forSegmentAtIndex:(NSUInteger)segment
{
    if (!count || !_items) {
        return;
    }
    
    NSAssert(segment < self.numberOfSegments, @"Cannot assign a count to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign a title to a negative segment.");
    
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@",[_items objectAtIndex:segment]];
    if (_showsCount) {
        NSString *breakString = @"\n";
        NSString *countString = [NSString stringWithFormat:@"%@", count];
        NSString *resultString = _inverseTitles ? [breakString stringByAppendingString:countString] : [countString stringByAppendingString:breakString];
        
        [title insertString:resultString atIndex:_inverseTitles ? title.length : 0];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [self setAttributedTitle:attributedString forSegmentAtIndex:segment];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedString forSegmentAtIndex:(NSUInteger)segment
{
    UIButton *button = [self buttonAtIndex:segment];
    button.titleLabel.numberOfLines = (_showsCount) ? 2 : 1;
    
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    [button setAttributedTitle:attributedString forState:UIControlStateHighlighted];
    [button setAttributedTitle:attributedString forState:UIControlStateSelected];
    [button setAttributedTitle:attributedString forState:UIControlStateDisabled];
    
    [self setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self setTitleColor:[self titleColorForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [self setTitleColor:[self titleColorForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [self setTitleColor:[self titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];
    
    _selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    NSAssert([color isKindOfClass:[UIColor class]], @"Cannot assign a title color with an unvalid color object.");
    
    for (UIButton *button in [self buttons]) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[button attributedTitleForState:state]];
        NSString *string = attributedString.string;
        
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        style.lineBreakMode = (_showsCount) ? NSLineBreakByWordWrapping : NSLineBreakByTruncatingTail;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.minimumLineHeight = 16.0;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
        
        if (_showsCount) {
            
            NSArray *components = [attributedString.string componentsSeparatedByString:@"\n"];
            
            if (components.count < 2) {
                return;
            }

            NSString *count = [components objectAtIndex:_inverseTitles ? 1 : 0];
            NSString *title = [components objectAtIndex:_inverseTitles ? 0 : 1];
            
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:_font.fontName size:19.0] range:[string rangeOfString:count]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:_font.fontName size:12.0] range:[string rangeOfString:title]];
            
            if (state == UIControlStateNormal) {
                
                UIColor *topColor = _inverseTitles ? [color colorWithAlphaComponent:0.5] : color;
                UIColor *bottomColor = _inverseTitles ? color : [color colorWithAlphaComponent:0.5];

                NSUInteger topLength = _inverseTitles ? title.length : count.length;
                NSUInteger bottomLength = _inverseTitles ? count.length : title.length;
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:topColor range:NSMakeRange(0, topLength)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:bottomColor range:NSMakeRange(topLength, bottomLength+1)];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
                
                if (state == UIControlStateSelected) {
                    _selectionIndicator.backgroundColor = color;
                }
            }
        } else {
            [attributedString addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, attributedString.string.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedString.string.length)];
        }
        
        [button setAttributedTitle:attributedString forState:state];
    }
    
    NSString *key = [NSString stringWithFormat:@"UIControlState%d", (int)state];
    [self.colors setObject:color forKey:key];
}

- (void)setSelected:(BOOL)selected forSegmentAtIndex:(NSUInteger)segment
{
    if (_selectedSegmentIndex == segment || self.isTransitioning) {
        return;
    }
    
    for (UIButton *_button in [self buttons]) {
        _button.highlighted = NO;
        _button.selected = NO;
        _button.userInteractionEnabled = YES;
    }
    
    CGFloat duration = (_selectedSegmentIndex < 0) ? 0.0 : _animationDuration;
    
    _selectedSegmentIndex = segment;
    _transitioning = YES;
    
    UIButton *button = [self buttonAtIndex:segment];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _selectionIndicator.frame = [self selectionIndicatorRect];
                     }
                     completion:^(BOOL finished) {
                         button.userInteractionEnabled = NO;
                         _transitioning = NO;
                     }];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setDisplayCount:(BOOL)count
{
    if (_showsCount == count) {
        return;
    }
    
    _showsCount = count;
    
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
    
    _selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setFont:(UIFont *)font
{
    if ([_font.fontName isEqualToString:font.fontName]) {
        return;
    }
    
    _font = font;
    
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
    
    _selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment
{
    UIButton *button = [self buttonAtIndex:segment];
    button.enabled = enabled;
}

- (void)setHairlineColor:(UIColor *)color
{
    if (_initializing) {
        return;
    }
    
    _hairline.backgroundColor = color;
}


#pragma mark - DZNSegmentedControl Methods

- (void)insertAllSegments
{
    for (int i = 0; i < self.numberOfSegments; i++) {
        [self addButtonForSegment:i];
    }
}

- (void)addButtonForSegment:(NSUInteger)segment
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:@selector(willSelectedButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(didSelectedButton:) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragInside|UIControlEventTouchDragEnter|UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    button.backgroundColor = nil;
    button.opaque = YES;
    button.clipsToBounds = YES;
    button.adjustsImageWhenHighlighted = NO;
    button.adjustsImageWhenDisabled = NO;
    button.exclusiveTouch = YES;
    button.tag = segment;
    
    [self addSubview:button];
}

- (void)configureSegments
{
    for (UIButton *button in [self buttons]) {
        
        NSAttributedString *attributedString = [button attributedTitleForState:UIControlStateNormal];
        
        if (attributedString.string.length > 0) {
            continue;
        }
        
        [self configureButtonForSegment:button.tag];
    }
    
    _selectionIndicator.frame = [self selectionIndicatorRect];
    _selectionIndicator.backgroundColor = self.tintColor;
}

- (void)configureButtonForSegment:(NSUInteger)segment
{
    if (_showsCount) {
        [self setCount:[self countForSegmentAtIndex:segment] forSegmentAtIndex:segment];
    }
    else {
        [self setTitle:[_items objectAtIndex:segment] forSegmentAtIndex:segment];
    }
}

- (void)willSelectedButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (!self.isTransitioning) {
        self.selectedSegmentIndex = button.tag;
    }
}

- (void)didSelectedButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    button.highlighted = NO;
    button.selected = YES;
}

- (void)removeAllSegments
{
    if (self.isTransitioning) {
        return;
    }
    
    for (UIButton *_button in [self buttons]) {
        [_button removeFromSuperview];
    }
    
    _items = nil;
}

@end
