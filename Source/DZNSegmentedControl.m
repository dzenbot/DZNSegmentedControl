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

@interface DZNStaticButton : UIButton
@end

@interface DZNSegmentedControl ()

@property (nonatomic) BOOL initializing;
@property (nonatomic, strong) UIView *selectionIndicator;
@property (nonatomic, strong) UIView *hairline;
@property (nonatomic, strong) NSMutableDictionary *colors;
@property (nonatomic, strong) NSMutableArray *counts; // of NSNumber

@property (nonatomic, assign) CGPoint scrollOffset;

@property (nonatomic, getter = isImageMode) BOOL imageMode; // Default NO

@end

@implementation DZNSegmentedControl
@synthesize height = _height;
@synthesize width = _width;

#pragma mark - Initialize Methods

- (id)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = CGRectGetWidth(frame);
        _height = CGRectGetHeight(frame);

        [self commonInit];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        [self commonInit];
        self.items = items;
    }
    return self;
}

- (void)commonInit
{
    _initializing = YES;
    
    _showsCount = YES;
    _selectedSegmentIndex = 0;
    _selectionIndicatorHeight = 2.0f;
    _animationDuration = 0.2;
    _autoAdjustSelectionIndicatorWidth = YES;
    _adjustsButtonTopInset = YES;
    _disableSelectedSegment = YES;
    _font = [UIFont systemFontOfSize:15.0f];
    
    _selectionIndicator = [UIView new];
    _selectionIndicator.backgroundColor = self.tintColor;
    [self addSubview:_selectionIndicator];
    
    _hairline = [UIView new];
    _hairline.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_hairline];
    
    _colors = [NSMutableDictionary new];
    _counts = [NSMutableArray array];
    
    _initializing = NO;
}


#pragma mark - UIView Methods

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake((self.width ? self.width : self.superview.bounds.size.width), self.height);
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
        _selectedSegmentIndex = DZNSegmentedControlNoSegment;
    }
    
    [[self buttons] enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        
        CGFloat width = self.bounds.size.width / self.numberOfSegments;
        CGFloat height = self.bounds.size.height;
        CGFloat x = width*idx;

        CGRect rect = CGRectMake(x, 0.0f, width, height);
        
        [button setFrame:rect];
        
        if (_adjustsButtonTopInset) {
            CGFloat topInset = (self.barPosition > UIBarPositionBottom) ? -4.0f : 4.0f;
            button.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, topInset, 0.0f);
        }
        else {
            button.titleEdgeInsets = UIEdgeInsetsZero;
        }
        
        if (idx == self.selectedSegmentIndex) {
            button.selected = YES;
        }
    }];
    
    [self configureAccessoryViews];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self configureSegments];
    
    [self layoutIfNeeded];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.width, self.height);
}


#pragma mark - Getter Methods

- (CGFloat)height
{
    return (_height ? : self.showsCount ? 56.0f : 30.0f);
}

- (CGFloat)width
{
    return (_width ? : self.superview.bounds.size.width);
}

- (NSUInteger)numberOfSegments
{
    return self.items.count;
}

- (NSArray *)buttons
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [DZNStaticButton class]];
    return [self.subviews filteredArrayUsingPredicate:predicate];
}

- (DZNStaticButton *)buttonAtIndex:(NSUInteger)segment
{
    if (self.items.count > 0 && segment < [self buttons].count) {
        return (DZNStaticButton *)[[self buttons] objectAtIndex:segment];
    }
    return nil;
}

- (DZNStaticButton *)selectedButton
{
    if (self.selectedSegmentIndex >= 0) {
        return [self buttonAtIndex:self.selectedSegmentIndex];
    }
    return nil;
}

- (NSString *)stringForSegmentAtIndex:(NSUInteger)segment
{
    if (self.isImageMode) {
        return nil;
    }
    
    DZNStaticButton *button = [self buttonAtIndex:segment];
    return [[button attributedTitleForState:UIControlStateNormal] string];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment
{
    if (self.isImageMode) {
        return nil;
    }
    
    if (self.showsCount) {
        NSString *title = [self stringForSegmentAtIndex:segment];
        NSArray *components = [title componentsSeparatedByString:@"\n"];
        
        if (components.count == 2) {
            return components[self.inverseTitles ? 0 : 1];
        }
        else return nil;
    }
    return self.items[segment];
}

- (NSNumber *)countForSegmentAtIndex:(NSUInteger)segment
{
    if (self.isImageMode) {
        return nil;
    }
    
    return segment < self.counts.count ? self.counts[segment] : @(0);
}

- (UIColor *)titleColorForState:(UIControlState)state
{
    if (self.isImageMode) {
        return nil;
    }
    
    NSString *key = [NSString stringWithFormat:@"UIControlState%d", (int)state];
    UIColor *color = [self.colors objectForKey:key];
    
    if (!color) {
        switch (state) {
            case UIControlStateNormal:              return [UIColor darkGrayColor];
            case UIControlStateDisabled:            return [UIColor lightGrayColor];
            case UIControlStateSelected:            return self.tintColor;
            default:                                return self.tintColor;
        }
    }
    
    return color;
}

- (BOOL)showsCount
{
    if (self.isImageMode) {
        return NO;
    }
    
    return _showsCount;
}

- (BOOL)autoAdjustSelectionIndicatorWidth
{
    if (self.isImageMode) {
        return NO;
    }
    
    return _autoAdjustSelectionIndicatorWidth;
}

- (CGRect)selectionIndicatorRect
{
    DZNStaticButton *button = [self selectedButton];
    
    if (!button) {
        // Let's then grab the first button, so the selection indicator is always aligned correctly.
        button = [self buttonAtIndex:0];
    }
    
    id item = self.items[button.tag];
    
    if ([item isKindOfClass:[NSString class]]) {
        if ([(NSString *)item length] == 0) {
            return CGRectZero;
        }
    }
    
    CGRect frame = CGRectZero;
    CGFloat appropriateY = button.frame.size.height-self.selectionIndicatorHeight;
    
    if (self.selectionIndicatorPosition != UIBarPositionAny) {
        frame.origin.y = (self.selectionIndicatorPosition > UIBarPositionBottom) ? 0.0f : appropriateY;
    }
    else {
        frame.origin.y = (self.barPosition > UIBarPositionBottom) ? 0.0f : appropriateY;
    }
    
    if (self.autoAdjustSelectionIndicatorWidth) {
        
        NSAttributedString *attributedString = [button attributedTitleForState:UIControlStateSelected];
        
        CGFloat width = [attributedString size].width;
        
        // Do not exceed the bounds of the button
        if (width > button.frame.size.width) {
            width = button.frame.size.width;
        }
        
        frame.size = CGSizeMake(width, self.selectionIndicatorHeight);
        frame.origin.x = (button.frame.size.width*(self.selectedSegmentIndex))+(button.frame.size.width-frame.size.width)/2;
    }
    else {
        frame.size = CGSizeMake(button.frame.size.width, self.selectionIndicatorHeight);
        frame.origin.x = (button.frame.size.width*(self.selectedSegmentIndex));
    }
    
    return frame;
}

- (UIColor *)hairlineColor
{
    return self.hairline.backgroundColor;
}

- (CGRect)hairlineRect
{
    CGFloat hairlineWidth = 1.0 / [UIScreen mainScreen].scale;
    
    CGRect frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, hairlineWidth);
    frame.origin.y = (self.barPosition > UIBarPositionBottom) ? 0.0f : self.frame.size.height;
    
    return frame;
}

// Calculate the most appropriate font size for a button title
- (CGFloat)appropriateFontSizeForTitle:(NSString *)title
{
    CGFloat fontSize = 14.0f;
    CGFloat minFontSize = 8.0f;
    
    if (!self.adjustsFontSizeToFitWidth) {
        return fontSize;
    }
    
    CGFloat buttonWidth = roundf(self.bounds.size.width/self.numberOfSegments);
    
    CGSize constraintSize = CGSizeMake(buttonWidth, MAXFLOAT);
    
    do {
        // Creates a new font instance with the current font size
        UIFont *font = [UIFont fontWithName:self.font.fontName size:fontSize];
        
        CGRect textRect = [title boundingRectWithSize:constraintSize options:0 attributes:@{NSFontAttributeName:font} context:nil];
        
        // If the new text rect's width matches the constraint width, return the font size
        if (textRect.size.width <= constraintSize.width) {
            return fontSize;
        }
        
        // Decreases the font size and tries again
        fontSize -= 1.0f;
        
    } while (fontSize > minFontSize);
    
    return fontSize;
}

- (UIBarPosition)barPosition
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(positionForBar:)]) {
        return [self.delegate positionForBar:self];
    }
    return UIBarPositionAny;
}

- (UIBarPosition)selectionIndicatorPosition
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(positionForSelectionIndicator:)]) {
        return [self.delegate positionForSelectionIndicator:self];
    }
    return UIBarPositionAny;
}


#pragma mark - Setter Methods

- (void)setDelegate:(id<DZNSegmentedControlDelegate>)delegate
{
    _delegate = delegate;
    
    [self layoutIfNeeded];
}

- (void)setFrame:(CGRect)frame
{
    _width = CGRectGetWidth(frame);
    _height = CGRectGetHeight(frame);
    
    [super setFrame:frame];
    
    [self layoutIfNeeded];
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    
    [self layoutSubviews];
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    
    [self layoutSubviews];
}

- (void)setItems:(NSArray *)items
{
    if (_items) {
        [self removeAllSegments];
    }
    
    if (items.count == 0) {
        _items = nil;
        return;
    }
    
    id firstItem = [items firstObject];
    
    _imageMode = [firstItem isKindOfClass:[UIImage class]];
    
#if DEBUG
    Class class = _imageMode ? [UIImage class] : [NSString class];
    
    // Consider cases where NSCFConstantString can also be used
    class = [class isSubclassOfClass:[NSString class]] ? [NSString class] : class;
    
    __unused NSPredicate *classPredicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", class];
    NSAssert([items filteredArrayUsingPredicate:classPredicate].count == items.count, @"Cannot include different objects in the array. Please make sure to either pass an array of NSString or UIImage objects.");
#endif
    
    _items = [NSArray arrayWithArray:items];
    
    if (!_imageMode) {
        _counts = [NSMutableArray arrayWithCapacity:items.count];
        
        for (int i = 0; i < items.count; i++) {
            [self.counts addObject:@0];
        }
    }
    
    [self insertAllSegments];
}

- (void)setTintColor:(UIColor *)color
{
    if (!color || !self.items || self.initializing) {
        return;
    }
    
    [super setTintColor:color];
    
    if (self.isImageMode) {

        for (DZNStaticButton *btn in self.buttons) {
            
            UIImage *normalImage = [btn imageForState:UIControlStateNormal];
            UIImage *selectedImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            [btn setImage:selectedImage forState:UIControlStateSelected];
            btn.tintColor = color;
        }
    }
    else {
        [self setTitleColor:color forState:UIControlStateSelected];
    }
    
    self.selectionIndicator.backgroundColor = color;
}

- (void)setHairlineColor:(UIColor *)color
{
    if (self.initializing) {
        return;
    }
    
    self.hairline.backgroundColor = color;
}

- (void)setSelectedSegmentIndex:(NSInteger)segment
{
    [self setSelectedSegmentIndex:segment animated:NO];
}

- (void)setSelectedSegmentIndex:(NSInteger)segment animated:(BOOL)animated
{
    if (self.numberOfSegments == 0 || self.selectedSegmentIndex == segment) {
        return;
    }
    
    [self unselectAllButtons];
    [self enableAllButtonsInteraction:YES];
    
    _selectedSegmentIndex = segment;
    
    BOOL showSelectorIndicator = (segment >= 0 && segment < self.numberOfSegments);
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut;

    UIButton *button = [self buttonAtIndex:segment];
    button.selected = YES;
    
    if (self.disableSelectedSegment) {
        button.userInteractionEnabled = NO;
    }
    
    void (^animations)() = ^void(){
        if (showSelectorIndicator) {
            self.selectionIndicator.frame = [self selectionIndicatorRect];
            self.selectionIndicator.alpha = 1.0f;
        }
        else {
            self.selectionIndicator.alpha = 0.0f;
        }
    };
    
    if (animated) {
        CGFloat damping = !self.bouncySelectionIndicator ? : 0.65f;
        CGFloat velocity = !self.bouncySelectionIndicator ? : 0.5f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0f
             usingSpringWithDamping:damping
              initialSpringVelocity:velocity
                            options:options
                         animations:animations
                         completion:NULL];
    }
    else {
        animations();
    }
}

- (void)setTintColor:(UIColor *)tintColor forSegmentAtIndex:(NSUInteger)segment
{
    if (!tintColor) {
        return;
    }
    
    NSAssert(segment < self.numberOfSegments, @"Cannot assign a tint color to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign a tint color to a negative segment.");
    
    NSAssert([tintColor isKindOfClass:[UIColor class]], @"Cannot assign a tint color with an unvalid color object.");
    
    DZNStaticButton *button = [self buttonAtIndex:segment];
    
    if (!self.isImageMode) {
        button.backgroundColor = tintColor;
    }
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    if (!title || self.isImageMode) {
        return;
    }
    
    NSAssert(segment <= self.numberOfSegments, @"Cannot assign a title to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign a title to a negative segment.");
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    
    if (segment >= self.numberOfSegments) {
        [items insertObject:title atIndex:self.numberOfSegments];
        [self addButtonForSegment:segment];
    }
    else {
        [items replaceObjectAtIndex:segment withObject:title];
        [self setCount:[self countForSegmentAtIndex:segment] forSegmentAtIndex:segment];
    }
    
    _items = items;
}

- (void)setCount:(NSNumber *)count forSegmentAtIndex:(NSUInteger)segment
{
    if (!count || !self.items || self.isImageMode) {
        return;
    }
    
    NSAssert(segment < self.numberOfSegments, @"Cannot assign a count to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign a title to a negative segment.");
    
    self.counts[segment] = count;
    
    [self configureSegments];
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment
{
    if (!image || !self.isImageMode) {
        return;
    }
    
    NSAssert(segment <= self.numberOfSegments, @"Cannot assign an image to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign an image to a negative segment.");
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    
    if (segment >= self.numberOfSegments) {
        [items insertObject:image atIndex:self.numberOfSegments];
        [self addButtonForSegment:segment];
    }
    else {
        [items replaceObjectAtIndex:segment withObject:image];
    }
    
    [self configureButtonImage:image forSegment:segment];
    
    _items = items;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedString forSegmentAtIndex:(NSUInteger)segment
{
    DZNStaticButton *button = [self buttonAtIndex:segment];
    button.titleLabel.numberOfLines = (self.showsCount) ? 2 : 1;
    
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    [button setAttributedTitle:attributedString forState:UIControlStateSelected];
    [button setAttributedTitle:attributedString forState:UIControlStateDisabled];
    
    [self setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self setTitleColor:[self titleColorForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [self setTitleColor:[self titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];
    
    [self configureAccessoryViews];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    if (self.isImageMode) {
        return;
    }
    
    NSAssert([color isKindOfClass:[UIColor class]], @"Cannot assign a title color with an unvalid color object.");
    
    for (DZNStaticButton *btn in [self buttons]) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[btn attributedTitleForState:state]];
        NSString *string = attributedString.string;
        
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        style.lineBreakMode = (self.showsCount) ? NSLineBreakByWordWrapping : NSLineBreakByTruncatingTail;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.minimumLineHeight = 20.0f;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
        
        if (self.showsCount) {
            
            NSArray *components = [attributedString.string componentsSeparatedByString:@"\n"];
            
            if (components.count < 2) {
                return;
            }
            
            NSString *count = [components objectAtIndex:self.inverseTitles ? 1 : 0];
            NSString *title = [components objectAtIndex:self.inverseTitles ? 0 : 1];
            
            CGFloat fontSizeForTitle = [self appropriateFontSizeForTitle:title];
            
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.font.fontName size:19.0f] range:[string rangeOfString:count]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.font.fontName size:fontSizeForTitle] range:[string rangeOfString:title]];
            
            if (state == UIControlStateNormal) {
                
                UIColor *topColor = self.inverseTitles ? [color colorWithAlphaComponent:0.5f] : color;
                UIColor *bottomColor = self.inverseTitles ? color : [color colorWithAlphaComponent:0.5f];
                
                NSUInteger topLength = self.inverseTitles ? title.length : count.length;
                NSUInteger bottomLength = self.inverseTitles ? count.length : title.length;
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:topColor range:NSMakeRange(0, topLength)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:bottomColor range:NSMakeRange(topLength, bottomLength+1)];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
                
                if (state == UIControlStateSelected) {
                    self.selectionIndicator.backgroundColor = color;
                }
            }
        }
        else {
            [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedString.string.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedString.string.length)];
        }
        
        [btn setAttributedTitle:attributedString forState:state];
    }
    
    NSString *key = [NSString stringWithFormat:@"UIControlState%d", (int)state];
    [self.colors setObject:color forKey:key];
}

- (void)setDisplayCount:(BOOL)count
{
    if (self.showsCount == count) {
        return;
    }
    
    _showsCount = count;
    
    [self configureSegments];
}

- (void)setFont:(UIFont *)font
{
    if ( [self.font.fontName isEqualToString:font.fontName] && self.font.pointSize == font.pointSize ) {
        return;
    }
    
    _font = font;
    
    [self configureSegments];
}

- (void)setShowsGroupingSeparators:(BOOL)showsGroupingSeparators
{
    if (self.showsGroupingSeparators == showsGroupingSeparators) {
        return;
    }
    
    _showsGroupingSeparators = showsGroupingSeparators;
    
    [self configureSegments];
}

- (void)setNumberFormatter:(NSNumberFormatter *)numberFormatter
{
    if ([self.numberFormatter isEqual:numberFormatter]) {
        return;
    }
    
    _numberFormatter = numberFormatter;
    
    [self configureSegments];
}

- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment
{
    DZNStaticButton *button = [self buttonAtIndex:segment];
    button.enabled = enabled;
}

- (void)setScrollOffset:(CGPoint)scrollOffset contentSize:(CGSize)contentSize
{
    self.autoAdjustSelectionIndicatorWidth = NO;
    self.bouncySelectionIndicator = NO;
    
    CGFloat offset = 0.0;
    
    // Horizontal scroll
    if (self.scrollOffset.x != scrollOffset.x) {
        offset = scrollOffset.x/(contentSize.width/self.numberOfSegments);
    }
    // Vertical scroll
    else if (self.scrollOffset.y != scrollOffset.y) {
        offset = scrollOffset.y/(contentSize.height/self.numberOfSegments);
    }
    // Skip
    else {
        return;
    }
    
    CGFloat buttonWidth = roundf(self.width/self.numberOfSegments);
    
    CGRect indicatorRect = self.selectionIndicator.frame;
    indicatorRect.origin.x = (buttonWidth * offset);
    self.selectionIndicator.frame = indicatorRect;
    
    NSUInteger index = (NSUInteger)offset;
    
    if (offset == truncf(offset) && self.selectedSegmentIndex != index) {
        
        [self unselectAllButtons];
        [self.buttons[index] setSelected:YES];
        
        _selectedSegmentIndex = index;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    _scrollOffset = scrollOffset;
}

- (void)setAdjustsButtonTopInset:(BOOL)adjustsButtonTopInset
{
    _adjustsButtonTopInset = adjustsButtonTopInset;
    
    [self layoutSubviews];
}

- (void)setDisableSelectedSegment:(BOOL)disableSelectedSegment
{
    _disableSelectedSegment = disableSelectedSegment;
    
    DZNStaticButton *button = [self selectedButton];
    button.userInteractionEnabled = !disableSelectedSegment;
}


#pragma mark - DZNSegmentedControl Configuration

- (void)insertAllSegments
{
    for (int i = 0; i < self.numberOfSegments; i++) {
        [self addButtonForSegment:i];
    }
    
    if (self.isImageMode || self.window) {
        [self configureSegments];
    }
}

- (void)addButtonForSegment:(NSUInteger)segment
{
    DZNStaticButton *button = [DZNStaticButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchDown];
    
    button.backgroundColor = [UIColor clearColor];
    button.opaque = YES;
    button.clipsToBounds = YES;
    button.adjustsImageWhenHighlighted = NO;
    button.exclusiveTouch = YES;
    button.tag = segment;
    
    [self insertSubview:button belowSubview:self.selectionIndicator];
}

- (void)configureSegments
{
    for (DZNStaticButton *btn in [self buttons]) {
        [self configureButtonForSegment:btn.tag];
    }
    
    [self configureAccessoryViews];
}

- (void)configureAccessoryViews
{
    self.selectionIndicator.frame = [self selectionIndicatorRect];
    self.selectionIndicator.backgroundColor = self.tintColor;
    
    self.hairline.frame = [self hairlineRect];
}

- (void)configureButtonForSegment:(NSUInteger)segment
{
    NSAssert(segment < self.numberOfSegments, @"Cannot configure a button for a non-existing segment.");
    NSAssert(segment >= 0, @"Cannot configure a button for a negative segment.");
    
    id item = self.items[segment];
    
    if ([item isKindOfClass:[NSString class]]) {
        [self configureButtonTitle:item forSegment:segment];
    }
    else if ([item isKindOfClass:[UIImage class]]) {
        [self configureButtonImage:item forSegment:segment];
    }
}

- (void)configureButtonTitle:(NSString *)title forSegment:(NSUInteger)segment
{
    NSMutableString *mutableTitle = [NSMutableString stringWithString:title];
    
    if (self.showsCount) {
        NSNumber *count = [self countForSegmentAtIndex:segment];
        
        NSString *breakString = @"\n";
        NSString *countString;
        
        if (self.numberFormatter) {
            countString = [self.numberFormatter stringFromNumber:count];
        }
        else if (!self.numberFormatter && _showsGroupingSeparators) {
            countString = [[[self class] defaultFormatter] stringFromNumber:count];
        }
        else {
            countString = [NSString stringWithFormat:@"%@", count];
        }
        
        NSString *resultString = self.inverseTitles ? [breakString stringByAppendingString:countString] : [countString stringByAppendingString:breakString];
        
        [mutableTitle insertString:resultString atIndex:self.inverseTitles ? title.length : 0];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:mutableTitle];
    [self setAttributedTitle:attributedString forSegmentAtIndex:segment];
}

- (void)configureButtonImage:(UIImage *)image forSegment:(NSUInteger)segment
{
    DZNStaticButton *button = [self buttonAtIndex:segment];
    
    [button setImage:image forState:UIControlStateNormal];
    
    [self setAttributedTitle:nil forSegmentAtIndex:segment];
}

- (void)selectedButton:(DZNStaticButton *)sender
{
    [self setSelectedSegmentIndex:sender.tag animated:YES];
    
    if (self.selectedSegmentIndex != sender.tag || !self.disableSelectedSegment) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)unselectAllButtons
{
    [self.buttons setValue:@NO forKey:@"selected"];
}

- (void)enableAllButtonsInteraction:(BOOL)enable
{
    [self.buttons setValue:@(enable) forKey:@"userInteractionEnabled"];
}

- (void)removeAllSegments
{
    // Removes all the buttons
    [[self buttons] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _items = nil;
    _counts = nil;
}


#pragma mark - Class Methods

+ (NSNumberFormatter *)defaultFormatter
{
    static NSNumberFormatter *defaultFormatter;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        defaultFormatter = [[NSNumberFormatter alloc] init];
        defaultFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        [defaultFormatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    });
    
    return defaultFormatter;
}

@end


@implementation DZNStaticButton

- (void)setHighlighted:(BOOL)highlighted {
    // Let's not call super here, so there is no highlight state.
}

@end
