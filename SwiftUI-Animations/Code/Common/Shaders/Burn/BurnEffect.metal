//
//  BurnEffect.metal
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 21/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// --- Noise Functions (Unchanged) ---
float randomBurn(float2 st) {
    return fract(sin(dot(st.xy, float2(12.9898, 78.233))) * 43758.5453123);
}

float noise(float2 st) {
    float2 i = floor(st);
    float2 f = fract(st);
    float a = randomBurn(i);
    float b = randomBurn(i + float2(1.0, 0.0));
    float c = randomBurn(i + float2(0.0, 1.0));
    float d = randomBurn(i + float2(1.0, 1.0));
    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbmBurn(float2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// --- Main Shader (Refined Colors) ---
[[ stitchable ]] half4 burnEffect(float2 position, SwiftUI::Layer layer, float2 size, float progress, float time) {
    
    // Safety check
    if (size.x == 0 || size.y == 0) { return layer.sample(position); }
    
    // Normalize
    float2 uv = position / size;
    
    // 1. Noise Generation
    // Increased frequency slightly (uv * 8.0) for a tighter burn pattern
    float n = fbmBurn(uv * 8.0 + float2(0, time * 0.1)); // changed from 0.3 to 1
    
    // 2. Burn Threshold Logic
    float burnPath = uv.y + (n * 0.15);
    // Map progress so it starts fully visible (threshold > maximum burnPath) and ends invisible
    float threshold = (1.0 - progress) * 1.3 - 0.15;

    float dist = burnPath - threshold;

    // 3. REFINED Coloring Logic (No Black)
    if (dist < 0.0) {
        // Discard pixel (burnt away)
        return half4(0, 0, 0, 0);
        //    } else if (dist < 0.04) {
        //        // The immediate edge: Deep Red/Orange Ember (replaced black char)
        //        // R: 0.9, G: 0.1, B: 0.0
        //        return half4(0.9, 0.1, 0.0, 1);
        //    }
    } else if (dist < 0.04) {
        // Main fire body: Bright Orange
        // R: 1.0, G: 0.5, B: 0.0
        return half4(1.0, 0.5, 0.0, 1);
    } else if (dist < 0.08) {
        // Outer glow: Hot Yellow/White
        // R: 1.0, G: 0.9, B: 0.4
        return half4(1.0, 0.9, 0.4, 1);
    } else {
        // Original Content
        return layer.sample(position);
    }
}
