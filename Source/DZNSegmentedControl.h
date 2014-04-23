//
//  DZNSegmentedControl.h
//  DZNSegmentedControl
//  https://github.com/dzenbot/DZNSegmentedControl
//
//  Created by Ignacio Romero Zurbuchen on 3/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

@protocol DZNSegmentedControlDelegate;

/**
 * A drop-in replacement for UISegmentedControl showing multiple segment counts, to be used typically on a user profile.
 */
@interface DZNSegmentedControl : UIControl <UIBarPositioning, UIAppearance>

/** The control's delegate object, conforming to the UIBarPositioning protocol. */
@property (nonatomic, weak) id <DZNSegmentedControlDelegate> delegate;
/** The items displayed on the control. */
@property (nonatomic, retain) NSArray *items;
/** The index number identifying the selected segment (that is, the last segment touched). */
@property (nonatomic) NSInteger selectedSegmentIndex;
/** Returns the number of segments the receiver has. */
@property (nonatomic, readonly) NSUInteger numberOfSegments;
/** The height of the control. Default is 56px. */
@property (nonatomic, readonly) CGFloat height;
/** The height of the selection indicator. Default is 2px . */
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight UI_APPEARANCE_SELECTOR;
/** The duration of the indicator's animation. Default is 0.2 sec. */
@property (nonatomic, readwrite) CGFloat animationDuration UI_APPEARANCE_SELECTOR;
/** The font family to be used on labels. Default is system font (HelveticaNeue). Font size is managed by the class. */
@property (nonatomic, retain) UIFont *font UI_APPEARANCE_SELECTOR;
/** The color of the hairline. Default is light gray. To hide the hairline, just set clipsToBounds to YES, like you would do it for UIToolBar & UINavigationBar. */
@property (nonatomic, readwrite) UIColor *hairlineColor UI_APPEARANCE_SELECTOR;
/** YES to display the count number on top of the titles. Default is YES.  */
@property (nonatomic) BOOL showsCount;
/** YES to adjust the width of the selection indicator on the title width. Default is YES.  */
@property (nonatomic) BOOL autoAdjustSelectionIndicatorWidth;

@property (nonatomic) BOOL inverseTitles;

/**
 * Initializes and returns a segmented control with segments having the given titles or images.
 * The returned segmented control is automatically sized to fit its content within the width of its superview.
 * If items is nil, the control will still be created but expecting titles and counts to be assigned.
 *
 * @params items An array of NSString objects only.
 * @returns A DZNSegmentedControl object or nil if there was a problem in initializing the object.
 */
- (id)initWithItems:(NSArray *)items;

/**
 * Sets the title of a segment.
 *
 * @param title A string to display in the segment as its title.
 * @param segment An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;

/**
 * Sets the title color for a particular state.
 *
 * @param color A color to be rendered for each the segment's state.
 * @param state The state that uses the styled title. The possible values are described in UIControlState.
 */
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

/**
 * Sets the count of a segment.
 *
 * @param count A number to display in the segment as its count.
 * @param segment An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)setCount:(NSNumber *)count forSegmentAtIndex:(NSUInteger)segment;

/**
 * Enables the specified segment.
 *
 * @param enabled YES to enable the specified segment or NO to disable the segment. By default, segments are enabled.
 * @param segment An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment;

/**
 * Returns the title of the specified segment.
 *
 * @param segment An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 * @returns Returns the string (title) assigned to the receiver as content. If no title has been set, it returns nil.
 */
- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment;

/**
 * Returns the count of the specified segment.
 *
 * @param segment An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 * @returns Returns the number (count) assigned to the receiver as content. If no count has been set, it returns 0.
 */
- (NSNumber *)countForSegmentAtIndex:(NSUInteger)segment;

/**
 * Removes all segments of the receiver
 */
- (void)removeAllSegments;

@end

/**
 * The DZNSegmentedControlDelegate protocol defines the interface that DZNSegmentedControl delegate objects implement to manage the segmented control behavior. This protocol declares no methods of its own but conforms to the UIBarPositioningDelegate protocol to support the positioning of a segmented control when it is moved to a window.
 */
@protocol DZNSegmentedControlDelegate <UIBarPositioningDelegate>
@end
