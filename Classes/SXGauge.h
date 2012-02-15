#import <Foundation/Foundation.h>
#import "Sparrow.h"

/// An SXGauge displays a texture, trimmed to its left side, depending on a ratio. 
/// This can be used to display a progress bar or a time gauge.
@interface SXGauge : SPSprite 
{
  @private
    SPImage *mImage;
    float mRatio;
}

/// Indicates how much of the texture is displayed. Range: 0.0f - 1.0f
@property (nonatomic, assign) float ratio;

/// Initializes a gauge with a certain texture
- (id)initWithTexture:(SPTexture*)texture;

/// Factory method.
+ (SXGauge *)gaugeWithTexture:(SPTexture *)texture;

@end