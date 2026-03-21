//
//  PixelSnap.metal
//  SwiftUI-Animations
//
//  Created by Shubham on 21/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h> // Required for SwiftUI types

using namespace metal;


[[ stitchable ]] half4 pixelSnap(float2 position, SwiftUI::Layer layer, float progress, float2 size) {
    // Invert progress so 0.0 is huge pixels, 1.0 is no pixels
    float p = 1.0 - progress;
    
    // Calculate pixel size.
    // At progress 0, size is 50px. At progress 1, size is 1px (normal)
    float pxSize = 1.0 + (p * p * 50.0); // p*p makes the ease-out smoother
    
    // Snap current coordinate to the nearest "pixel block"
    float2 blockPos = floor(position / pxSize) * pxSize;
    
    // Sample the center of that block
    half4 color = layer.sample(blockPos + (pxSize / 2.0));
    
    // Fade in opacity as it clarifies
    return color * progress;
}
