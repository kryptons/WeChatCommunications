
#import <UIKit/UIKit.h>

#define kJSAnimatedImagesViewDefaultTimePerImage 20.0f

@protocol RCAnimatedImagesViewDelegate;

@interface RCAnimatedImagesView : UIView

@property (nonatomic, assign) id<RCAnimatedImagesViewDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval timePerImage;

- (void)startAnimating;
- (void)stopAnimating;

- (void)reloadData;

@end

@protocol RCAnimatedImagesViewDelegate
- (NSUInteger)animatedImagesNumberOfImages:(RCAnimatedImagesView *)animatedImagesView;
- (UIImage *)animatedImagesView:(RCAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index;
@end
