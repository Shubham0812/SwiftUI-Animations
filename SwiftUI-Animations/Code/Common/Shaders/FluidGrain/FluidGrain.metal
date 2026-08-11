//
//  FluidGrain.metal
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 09/08/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Pseudo-random noise used for the film grain. Named uniquely so it doesn't
// collide with helpers of the same purpose in other shaders' Metal files.
float fluidGrainRandom(float2 p) {
    return fract(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453123);
}

/// A slow, smoky vertical wave of `glowColor` over black, with a film-grain overlay.
/// - `time` drives the motion; - `glowColor` tints the glowing wave.
[[ stitchable ]] half4 fluidGrain(float2 position, half4 currentColor, float time, half4 glowColor) {

    // Normalize coordinates (~0.0 to 0.5 on X, ~0.0 to 1.1 on Y for standard phones)
    float2 uv = position / 800.0;

    // Keep the speed slow and elegant
    float t = time * 0.3;

    float2 warpedUV = uv;

    // 1. Fold the Y Space
    // We distort the Y axis based on X. This causes the wave to compress and stretch
    // vertically, which gives it that distinctly "smoky" folded look.
    warpedUV.y += sin(uv.x * 5.0 - t) * 0.15;

    // 2. Create the Snaking Wave
    // We heavily warp the X axis using multiple sine waves.
    // The maximum this math can swing is mathematically capped at ±0.20.
    warpedUV.x += sin(warpedUV.y * 4.0 + t * 1.2) * 0.12 + cos(warpedUV.y * 2.5 - t * 0.9) * 0.08;

    // 3. The Anchor Path
    // We draw a straight line at X = 0.55 in this deeply warped space.
    // Because the space itself is snaking back and forth, the straight line becomes a fluid wave.
    float path = 0.55;
    float distanceToCurve = abs(warpedUV.x - path);

    // 4. Glow Falloff
    // A distance of 0.3 guarantees the glow reaches the left side of the screen
    // but smoothly fades out before consuming the pure black corner.
    float glow = 1.0 - smoothstep(0.0, 0.3, distanceToCurve);

    // 5. Internal Smoky Texture
    // Adds faint dark wisps inside the color so it isn't a solid, flat fill.
    glow *= (sin(warpedUV.y * 12.0 - t * 2.0) * 0.1 + 0.9);
    glow = clamp(glow, 0.0, 1.0);

    // 6. Colors and Grain
    half4 bgColor = half4(0.0, 0.0, 0.0, 1.0);
    half4 finalColor = mix(bgColor, glowColor, half(glow));

    float noise = fluidGrainRandom(position + float2(time * 50.0, -time * 50.0));
    finalColor.rgb += half3(noise * 0.12);

    return finalColor;
}
