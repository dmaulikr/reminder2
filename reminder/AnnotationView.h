//
//  AnnotationView.h
//  reminder
//
//  Created by Nikola on 6/20/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface AnnotationView : MKAnnotationView
@property (weak, nonatomic) IBOutlet UIView *vContent;
@property (nonatomic,retain)UIView *contentView;
@end
