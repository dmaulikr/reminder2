//
//  AlarmCell.m
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AlarmCell.h"
@interface AlarmCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblDateAlarm;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblAlarm;


@end

@implementation AlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
