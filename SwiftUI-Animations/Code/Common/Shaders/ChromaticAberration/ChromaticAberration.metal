//
//  ChromaticAberration.metal
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Splits the R, G, and B channels radially outward from the image centre,
// creating a prism / holographic lens-fringing effect.
// `strength` controls the maximum offset in pixels; `time` drives a subtle pulse.
[[ stitchable ]] half4 chromaticAberration(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float strength,
    float time
) {
    if (size.x == 0 || size.y == 0) { return layer.sample(position); }

    float2 uv       = position / size;
    float2 center   = float2(0.5, 0.5);
    float2 dir      = uv - center;
    float  dist     = length(dir);

    // Slow breathing pulse so the aberration lives even when idle
    float pulse     = 1.0 + 0.25 * sin(time * 2.4);
    float scale     = strength * pulse;

    // R pushed outward, B pulled inward — G stays in place
    float2 rOffset  = dir * dist * scale;
    float2 bOffset  = dir * dist * scale * -1.2;

    float r = layer.sample(position + rOffset).r;
    float g = layer.sample(position).g;
    float b = layer.sample(position + bOffset).b;
    float a = layer.sample(position).a;

    // Slight iridescent tint at the fringe edges
    float fringeMask = smoothstep(0.3, 0.7, dist);
    r += fringeMask * 0.06 * pulse;
    b += fringeMask * 0.04 * pulse;

    return half4(half(r), half(g), half(b), half(a));
}
