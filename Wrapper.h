//
//  Wrapper.h
//  SensorRecorder
//
//  Created by jarvis on 2021/9/21.
//

#ifndef Wrapper_h
#define Wrapper_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
 
@interface Wrapper: NSObject
+ (NSString *)openCVVersionString;
+ (UIImage *)cvtColorBGR2GRAY:(UIImage *)image;
@end
 
#endif /* Wrapper_h */
