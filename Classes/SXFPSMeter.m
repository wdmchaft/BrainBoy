#import "SXFPSMeter.h"

@implementation SXFPSMeter

- (id)initWithText:(NSString *)text{
	self = [super initWithText:text];
	self.hAlign = SPHAlignLeft;
	self.vAlign = SPVAlignTop;
	self.fontSize = 16;
	self.color = 0xFF0000;
	[self addEventListener:@selector(update:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
	return self;
}
static double totalTime = 0;

- (void)update:(SPEnterFrameEvent*)event{
	totalTime += event.passedTime;
		self.text = [NSString stringWithFormat:@"Score: %d",totalTime];
}

- (void)dealloc{
	[self removeEventListener:@selector(update:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
	[super dealloc];
}

@end
