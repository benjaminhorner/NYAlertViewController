//
//  NYAlertView.m
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "NYAlertView.h"

#import "NYAlertAction.h"
#import "NYRoundRectButton.h"

@interface NYAlertView ()

@property UIView *contentViewContainerView;
@property UIView *actionButtonContainerView;
@property (nonatomic) NSArray *actionButtons;

- (void)actionButtonPressed:(NYRoundRectButton *)button;

@end

@implementation NYAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleFont = [UIFont boldSystemFontOfSize:18.0f];
        self.messageFont = [UIFont systemFontOfSize:16.0f];
        self.buttonTitleFont = [UIFont systemFontOfSize:16.0f];
        self.cancelButtonTitleFont = [UIFont boldSystemFontOfSize:16.0f];
        
        self.buttonCornerRadius = 4.0f;
        
        _alertBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.alertBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.alertBackgroundView.backgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0f];
        self.alertBackgroundView.layer.cornerRadius = 4.0f;
        [self addSubview:_alertBackgroundView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.font = self.titleFont;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.text = NSLocalizedString(@"Title Label", nil);
        [self.alertBackgroundView addSubview:self.titleLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.messageLabel setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.textColor = [UIColor darkGrayColor];
        self.messageLabel.font = self.messageFont;
        self.messageLabel.text = NSLocalizedString(@"Message Label", nil);
        [self.alertBackgroundView addSubview:self.messageLabel];
        
        _contentViewContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentViewContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.alertBackgroundView addSubview:self.contentViewContainerView];
        
        _actionButtonContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.actionButtonContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.actionButtonContainerView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.alertBackgroundView addSubview:self.actionButtonContainerView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertBackgroundView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        CGFloat alertBackgroundViewWidth = MIN(CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds),
                                               CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds)) * 0.8f;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertBackgroundView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0f
                                                          constant:alertBackgroundViewWidth]];
        
        self.backgroundViewVerticalCenteringConstraint = [NSLayoutConstraint constraintWithItem:self.alertBackgroundView
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                     multiplier:1.0f
                                                                                       constant:0.0f];
        
        [self addConstraint:self.backgroundViewVerticalCenteringConstraint];
        
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:NSDictionaryOfVariableBindings(_titleLabel)]];
        
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_messageLabel]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_messageLabel)]];
        
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentViewContainerView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_contentViewContainerView)]];
        
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_actionButtonContainerView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_actionButtonContainerView)]];
        
        [self.alertBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-2-[_messageLabel][_contentViewContainerView]-[_actionButtonContainerView]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_titleLabel,
                                                                                                                           _messageLabel,
                                                                                                                           _contentViewContainerView,
                                                                                                                           _actionButtonContainerView)]];
    }
    
    return self;
}

// Pass through touches outside the backgroundView for the presentation controller to handle dismissal
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    
    self.titleLabel.font = titleFont;
}

- (void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    
    self.messageLabel.font = messageFont;
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont {
    _buttonTitleFont = buttonTitleFont;
    
    [self.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        NYAlertAction *action = self.actions[idx];
        
        if (action.style != UIAlertActionStyleCancel) {
            button.titleLabel.font = buttonTitleFont;
        }
    }];
}

- (void)setCancelButtonTitleFont:(UIFont *)cancelButtonTitleFont {
    _cancelButtonTitleFont = cancelButtonTitleFont;
    
    [self.actionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        NYAlertAction *action = self.actions[idx];
        
        if (action.style == UIAlertActionStyleCancel) {
            button.titleLabel.font = cancelButtonTitleFont;
        }
    }];
}

- (void)setButtonCornerRadius:(CGFloat)buttonCornerRadius {
    _buttonCornerRadius = buttonCornerRadius;
    
    for (NYRoundRectButton *button in self.actionButtons) {
        button.cornerRadius = buttonCornerRadius;
    }
}

- (void)setContentView:(UIView *)contentView {
    [self.contentView removeFromSuperview];
    
    _contentView = contentView;
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentViewContainerView addSubview:self.contentView];
    
    [self.contentViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:NSDictionaryOfVariableBindings(_contentView)]];
    
    [self.contentViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:NSDictionaryOfVariableBindings(_contentView)]];
}

- (void)actionButtonPressed:(NYRoundRectButton *)button {
    NYAlertAction *action = self.actions[button.tag];
    action.handler(action);
}

- (void)setActions:(NSArray *)actions {
    _actions = actions;
    
    NSMutableArray *buttons = [NSMutableArray array];
    
    // Create buttons for each action
    for (int i = 0; i < [actions count]; i++) {
        UIAlertAction *action = actions[i];
        
        NYRoundRectButton *button = [[NYRoundRectButton alloc] initWithFrame:CGRectZero];
        
        button.tag = i;
        [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        button.cornerRadius = self.buttonCornerRadius;
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button setTitle:action.title forState:UIControlStateNormal];
        
        if (action.style == UIAlertActionStyleCancel) {
            button.titleLabel.font = self.cancelButtonTitleFont;
        } else {
            button.titleLabel.font = self.buttonTitleFont;
        }
        
        if (action.style == UIAlertActionStyleCancel) {
//            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            button.tintColor = [UIColor darkGrayColor];
        } else if (action.style == UIAlertActionStyleDestructive) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.tintColor = [UIColor redColor];
        }
        
        [buttons addObject:button];
    }
    
    self.actionButtons = buttons;
}

- (void)setActionButtons:(NSArray *)actionButtons {
    for (UIButton *button  in self.actionButtons) {
        [button removeFromSuperview];
    }
    
    _actionButtons = actionButtons;
    
    // If there are 2 actions, display the buttons next to each other. Otherwise, stack the buttons vertically at full width
    if ([actionButtons count] == 2) {
        UIButton *firstButton = actionButtons[0];
        UIButton *lastButton = actionButtons[1];
        
        [self.actionButtonContainerView addSubview:firstButton];
        [self.actionButtonContainerView addSubview:lastButton];
        
        [self.actionButtonContainerView addConstraint:[NSLayoutConstraint constraintWithItem:firstButton
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:lastButton
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                  multiplier:1.0f
                                                                                    constant:0.0f]];
        
        [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[firstButton]-[lastButton]-|"
                                                                                               options:NSLayoutFormatAlignAllCenterY
                                                                                               metrics:nil
                                                                                                 views:NSDictionaryOfVariableBindings(firstButton, lastButton)]];
        
        [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[firstButton(40)]|"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:NSDictionaryOfVariableBindings(_contentViewContainerView, firstButton)]];
        
        [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastButton(40)]"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:NSDictionaryOfVariableBindings(lastButton)]];
    } else {
        for (int i = 0; i < [actionButtons count]; i++) {
            UIButton *actionButton = actionButtons[i];
            
            [self.actionButtonContainerView addSubview:actionButton];
            
            [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[actionButton]-|"
                                                                                                   options:0
                                                                                                   metrics:nil
                                                                                                     views:NSDictionaryOfVariableBindings(actionButton)]];
            
            [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[actionButton(40)]"
                                                                                                   options:0
                                                                                                   metrics:nil
                                                                                                     views:NSDictionaryOfVariableBindings(actionButton)]];
            
            if (i == 0) {
                [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[actionButton]"
                                                                                                       options:0
                                                                                                       metrics:nil
                                                                                                         views:NSDictionaryOfVariableBindings(_contentViewContainerView, actionButton)]];
            } else {
                UIButton *previousButton = actionButtons[i - 1];
                
                [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousButton]-[actionButton]"
                                                                                                       options:0
                                                                                                       metrics:nil
                                                                                                         views:NSDictionaryOfVariableBindings(previousButton, actionButton)]];
            }
            
            if (i == ([actionButtons count] - 1)) {
                [self.actionButtonContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[actionButton]|"
                                                                                                       options:0
                                                                                                       metrics:nil
                                                                                                         views:NSDictionaryOfVariableBindings(actionButton)]];
            }
        }
    }
}

@end