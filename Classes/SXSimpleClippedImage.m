/**
 * Licensed under the MIT license:
 * 
 *     http://www.opensource.org/licenses/mit-license.php
 * 
 * (c) Copyright 2011 David Wagner.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "SXSimpleClippedImage.h"

#define CLAMP(n, min, max) ((n) < (min) ? (min) : (n) > (max) ? (max) : (n))

@interface SXSimpleClippedImage () 

- (void)updateTextureCoordinates;
- (void)storeInitialValues;

@end

@implementation SXSimpleClippedImage

@synthesize	clipX;
@synthesize	clipY;
@synthesize	clipWidth;
@synthesize	clipHeight;
@synthesize	originalWidth;
@synthesize	originalHeight;

+ (SXSimpleClippedImage *)imageWithTexture:(SPTexture *)texture 
{
    return [[[SXSimpleClippedImage alloc] initWithTexture:texture] autorelease];
}

+ (SXSimpleClippedImage*)imageWithContentsOfFile:(NSString*)path
{
    return [[[SXSimpleClippedImage alloc] initWithContentsOfFile:path] autorelease];
}

- (void)storeInitialValues
{
	originalWidth = self.width;
	originalHeight = self.height;
	
	topLeft = [[SPPoint alloc] initWithX: 0.0 y:0.0];
	topRight = [[SPPoint alloc] initWithX: 1.0 y:0.0];
	bottomLeft = [[SPPoint alloc] initWithX: 0.0 y:1.0];
	bottomRight = [[SPPoint alloc] initWithX: 1.0 y:1.0];

	clipX = 0;
	clipY = 0;
	clipWidth = originalWidth;
	clipHeight = originalHeight;
}

- (id)initWithTexture:(SPTexture *)texture
{
    self = [super initWithTexture:texture];
    if (self) 
	{
		[self storeInitialValues];
    }
    
    return self;
}

- (id)initWithContentsOfFile:(NSString*)path
{
    self = [super initWithContentsOfFile:path];
    if (self) 
	{
		[self storeInitialValues];
    }
    
    return self;
}

- (void)dealloc 
{
	[topLeft release];
	[topRight release];
	[bottomLeft release];
	[bottomRight release];
	
    [super dealloc];
}

- (void)setClipX:(float)x
{
	clipX = x;
	[self updateTextureCoordinates];
}

- (void)setClipY:(float)y
{
	clipY = y;
	[self updateTextureCoordinates];
}

- (void)setClipWidth:(float)width
{
	clipWidth = width;
	[self updateTextureCoordinates];
}

- (void)setClipHeight:(float)height
{
	clipHeight = height;
	[self updateTextureCoordinates];
}

- (void)setClipX:(float)x Y:(float)y Width:(float)width Height:(float)height
{
	clipX = x;
	clipY = y;
	clipWidth = width;
	clipHeight = height;
	
	[self updateTextureCoordinates];
}

- (void)updateTextureCoordinates
{
	float cX = CLAMP(clipX, 0, originalWidth);
	float cY = CLAMP(clipY, 0, originalHeight);
	float cWidth = CLAMP(clipWidth, 0, originalWidth - cX);
	float cHeight = CLAMP(clipHeight, 0, originalHeight - cY);

	// Normalise the values for use as texture coordinates
	cX /= originalWidth;
	cY /= originalHeight;
	cWidth /= originalWidth;
	cHeight /= originalHeight;
	
	// Setup the cached point values
	topLeft.x = cX;
	topLeft.y = cY;
	
	topRight.x = cX + cWidth;
	topRight.y = cY;
	
	bottomLeft.x = cX;
	bottomLeft.y = cY + cHeight;
	
	bottomRight.x = cX + cWidth;
	bottomRight.y = cY + cHeight;
	
	// Copy them to the texture vertices
	[self setTexCoords:topLeft ofVertex:0];
	[self setTexCoords:topRight ofVertex:1];
	[self setTexCoords:bottomLeft ofVertex:2];
	[self setTexCoords:bottomRight ofVertex:3];
	
	// Update our scale so we are the correct width and height
	self.scaleX = cWidth;
	self.scaleY = cHeight;
}

@end
