//
//  EmberReveal.metal
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 21/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Noise helpers

float hashTwo(float2 p) {
    return fract(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
}

float valueNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float bottom = mix(hashTwo(i + float2(0, 0)), hashTwo(i + float2(1, 0)), f.x);
    float top    = mix(hashTwo(i + float2(0, 1)), hashTwo(i + float2(1, 1)), f.x);
    return mix(bottom, top, f.y);
}

// MARK: - Ember Reveal
// The image burns into existence from the centre outward with a glowing ember edge.
// progress: 0.0 = fully hidden, 1.0 = fully revealed
[[ stitchable ]] half4 emberReveal(float2 position,
                                   SwiftUI::Layer layer,
                                   float progress,
                                   float2 size) {
    float2 uv = position / size;

    // Multi-octave noise for a more organic edge
    float noise  = valueNoise(uv * 10.0) * 0.60
                 + valueNoise(uv * 20.0) * 0.25
                 + valueNoise(uv * 40.0) * 0.15;

    // Distance from centre (0 at centre, ~0.7 at corners)
    float dist = distance(uv, float2(0.5, 0.5));

    // Signed threshold: negative = hidden, positive = revealed
    float threshold = (progress * 1.5) - dist + (noise * 0.2);

    half4 color = layer.sample(position);

    if (threshold < 0.0) {
        // Not yet revealed — fully transparent
        return half4(0, 0, 0, 0);
    } else if (threshold < 0.15) {
        // Burning edge — blend an orange/red ember glow onto the pixel
        float edgeFactor = 1.0 - (threshold / 0.15);          // 1 at edge, 0 at interior
        half4 ember = half4(1.0, 0.4 + edgeFactor * 0.2, 0.0, 1.0);
        return mix(color, color + ember * half4(1, 1, 1, 0), half(edgeFactor));
    } else {
        // Fully revealed
        return color;
    }
}
