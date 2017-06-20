//
//  AnnotationView.m
//  reminder
//
//  Created by Nikola on 6/20/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AnnotationView.h"
@interface AnnotationView ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;


- (IBAction)action:(id)sender;


@end

@implementation AnnotationView
@synthesize contentView;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -120);
        self.frame = CGRectMake(0, 0, 250, 220);
        
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30 )];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        self.contentView = _contentView;
    }
    return self;
}
- (IBAction)action:(id)sender
{
    NSLog(@"annotation pressed");
}
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    [self annotaitonAction];
    return hitView;
}
- (void)annotaitonAction
{
    NSLog(@"annotation pressed ");
}

@end
