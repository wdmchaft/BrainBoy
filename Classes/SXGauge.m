#import "SXGauge.h"

@implementation SXGauge

@synthesize ratio = mRatio;

- (id)initWithTexture:(SPTexture*)texture
{
    if ((self = [super init]))
    {
        mRatio = 1.0f;
        mImage = [SPImage imageWithTexture:texture];
        [self addChild:mImage];
    }
    return self;
}

- (id)init
{
    return [self initWithTexture:[SPTexture emptyTexture]];
}

- (void)update
{
    
    mImage.scaleX = mRatio;
    [mImage setTexCoords:[SPPoint pointWithX:mRatio y:0.0f] ofVertex:1];
    [mImage setTexCoords:[SPPoint pointWithX:mRatio y:1.0f] ofVertex:3];
}

- (void)setRatio:(float)value
{
    mRatio = MAX(0.0f, MIN(1.0f, value));
    [self update];
}

+ (SXGauge *)gaugeWithTexture:(SPTexture *)texture
{
    return [[[SXGauge alloc] initWithTexture:texture] autorelease];
}

@end