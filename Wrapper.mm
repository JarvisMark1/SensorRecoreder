//
//  Wrapper.m
//  SensorRecorder
//
//  Created by jarvis on 2021/9/21.
//

#import "Wrapper.h"
#import <opencv2/opencv.hpp>
 
@implementation Wrapper : NSObject
 
+ (NSString *)openCVVersionString {
return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}
 
@end
