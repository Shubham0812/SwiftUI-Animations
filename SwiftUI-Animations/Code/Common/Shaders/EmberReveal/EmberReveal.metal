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
    float top = mix(hashTwo(i + float2(0, 1)), hashTwo(i + float2(1, 1)), f.x);
    return mix(bottom, top, f.y);
}
//
//// --- EFFECT 1: EMBER BURN ---
//// The image burns into existence from the center outward with a glowing edge.
[[ stitchable ]] half4 emberReveal(float2 position, SwiftUI::Layer layer, float progress, float2 size) {
    // Normalize coordinates
    float2 uv = position / size;
    
    // Create noise pattern
    float noise = valueNoise(uv * 10.0); // 10.0 is the noise scale
    
    // Calculate distance from center (0.0 at center, 0.7 at corners)
    float dist = distance(uv, float2(0.5, 0.5));
    
    // Combine distance and noise for the mask
    // Progress 0->1 moves the threshold from center to edges
    float threshold = (progress * 1.5) - dist + (noise * 0.2);
    
    half4 color = layer.sample(position);
    
    if (threshold < 0.0) {
        // Not revealed yet
        return half4(0, 0, 0, 0);
    } else if (threshold < 0.15) {
        // The "Burning Edge" (Orange/Red add-on)
        // We add bright orange to the image pixel
        return color + half4(1.0, 0.5, 0.0, 1.0);
    } else {
        // Fully revealed
        return color;
    }
}
