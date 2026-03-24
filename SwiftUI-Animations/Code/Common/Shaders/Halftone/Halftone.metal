//
//  Halftone.metal
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Classic newspaper halftone: each cell shows a circular ink dot whose radius
// is proportional to the cell's luminance (darker pixels → larger dots).
// `dotSize`  – cell size in points (e.g. 6–12 looks great).
// `progress` – animates the effect in (0 = fully original, 1 = full halftone).
[[ stitchable ]] half4 halftone(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float dotSize,
    float progress
) {
    if (size.x == 0 || size.y == 0) { return layer.sample(position); }

    // --- Grid snapping ---
    float2 cell       = floor(position / dotSize);
    float2 cellCenter = (cell + 0.5) * dotSize;

    // Sample the original colour at the cell centre
    half4  src        = layer.sample(cellCenter);

    // ITU-R BT.709 luminance
    float luma = dot(float3(src.rgb), float3(0.2126, 0.7152, 0.0722));

    // Normalised distance from cell centre (0 at centre, 1 at corner)
    float2 offset       = (position - cellCenter) / (dotSize * 0.5);
    float  distNorm     = length(offset);

    // Darker pixels → bigger dots (invert luminance for ink coverage)
    float  dotRadius    = (1.0 - luma) * 0.92;   // max coverage ~92%
    float  edge         = 0.06;                   // soft anti-alias band

    // Blend original ↔ halftone based on progress
    float  inDot        = 1.0 - smoothstep(dotRadius - edge, dotRadius + edge, distNorm);
    half4  ink          = half4(0.04, 0.04, 0.08, src.a);   // near-black ink
    half4  paper        = half4(0.96, 0.94, 0.89, src.a);   // warm cream paper

    half4  halftoneColor = mix(paper, ink, half(inDot));
    return mix(src, halftoneColor, half(progress));
}
