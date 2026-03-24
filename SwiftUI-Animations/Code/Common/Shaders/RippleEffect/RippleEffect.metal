//
//  RippleEffect.metal
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Returns the sample position offset by a decaying sine-wave ripple.
// The wave ring expands outward from `touchPoint` as `progress` goes 0 → 1.
[[ stitchable ]] float2 waveRipple(
    float2 position,
    float2 size,
    float2 touchPoint,
    float time,
    float progress
) {
    if (size.x == 0 || size.y == 0) { return position; }

    float2 uv       = position / size;
    float2 touchUV  = touchPoint / size;

    float2 delta    = uv - touchUV;
    float dist      = length(delta);

    // Expanding wavefront position (0 → 1.4 covers the whole image diagonal)
    float speed     = 1.4;
    float waveFront = progress * speed;

    // Gaussian envelope tightly centred on the wavefront
    float envelope  = exp(-pow((dist - waveFront) * 12.0, 2.0));

    // Radial direction; guard against zero-length at exact touch point
    float2 dir      = dist > 0.001 ? normalize(delta) : float2(0.0, 1.0);

    // Wave oscillation (phase travels outward with time)
    float frequency  = 28.0;
    float amplitude  = 0.018;
    float decay      = 1.0 - progress;          // amplitude fades as ring expands
    float displacement = sin(dist * frequency - time * 22.0) * amplitude * envelope * decay;

    return (uv + dir * displacement) * size;
}
