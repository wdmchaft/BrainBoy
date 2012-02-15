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

#import "SPImage.h"

/** --------------------------------------------------------------------------
 An SXSimpleClippedImage displays an image, clipped by the clip dimensions
 specified.
 
 Any part of the image within the clipping rectangle's dimensions will be
 visible. The coordinates of the clipping rectangle are relative to the image
 itself, so 0,0 is the top left of the image. The clip rectangle cannot be 
 larger than the original size of the image, or outside the image.
 
 Or, for the more mathematically minded:

 - 0 ≤ clipX ≤ originalWidth
 - 0 ≤ clipY ≤ originalHeight
 - 0 ≤ clipWidth ≤ (originalWidth - clipX)
 - 0 ≤ clipHeight ≤ (originalHeight - clipY)
 
 In order to not mess with tweens, you can set values other than those
 specified above, but the class will internally limit the values to those.
 Basically, that means you can use things like elastic tweens and not have
 to worry about them never finishing because they can't set values outside
 that range.
--------------------------------------------------------------------------- */

@interface SXSimpleClippedImage : SPImage
{
@private
	float originalWidth;
	float originalHeight;

	float clipX;
	float clipY;
	float clipWidth;
	float clipHeight;

	SPPoint *topLeft;
	SPPoint *topRight;
	SPPoint *bottomLeft;
	SPPoint *bottomRight;
}

/// --------------------
/// @name Initialization
/// --------------------

/// Initialize with a texture. _Designated Initializer_.
- (id)initWithTexture:(SPTexture *)texture;

/// Initialize  with a texture loaded from a file.
- (id)initWithContentsOfFile:(NSString*)path;

/// Set the clip rectangle
- (void)setClipX:(float)x Y:(float)y Width:(float)width Height:(float)height;

/// Factory method
+ (SXSimpleClippedImage*)imageWithTexture:(SPTexture *)texture;

/// Factory method
+ (SXSimpleClippedImage*)imageWithContentsOfFile:(NSString*)path;

/// ----------------
/// @name Properties
/// ----------------

/// The original width of the image
@property (nonatomic, readonly) float originalWidth;

/// The original height of the image
@property (nonatomic, readonly) float originalHeight;

/// The clipping rectangle's X origin
@property (nonatomic, assign) float clipX;

/// The clipping rectangle's Y origin
@property (nonatomic, assign) float clipY;

/// The width of the clipping rectangle
@property (nonatomic, assign) float clipWidth;

// The height of the clipping rectangle
@property (nonatomic, assign) float clipHeight;

@end
