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

// MARK: - Noise Utilities

/// Gradient-hash for two dimensions.
static float2 hash2(float2 p) {
    p = float2(dot(p, float2(127.1, 311.7)),
               dot(p, float2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

/// Smooth gradient noise in [-1, 1].
static float gradientNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    float2 u = f * f * (3.0 - 2.0 * f);   // smoothstep
    return mix(
        mix(dot(hash2(i + float2(0, 0)), f - float2(0, 0)),
            dot(hash2(i + float2(1, 0)), f - float2(1, 0)), u.x),
        mix(dot(hash2(i + float2(0, 1)), f - float2(0, 1)),
            dot(hash2(i + float2(1, 1)), f - float2(1, 1)), u.x),
        u.y);
}

/// Fractal Brownian Motion — sums several octaves of gradient noise.
static float fbm(float2 p) {
    float value     = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value     += amplitude * gradientNoise(p);
        p         *= 2.1;
        amplitude *= 0.5;
    }
    return value;
}

// MARK: - Burn Effect Shader

/// SwiftUI layer-effect shader that renders an animated burn / fire dissolve.
///
/// Parameters (passed via `ShaderLibrary.burnEffect(...)`):
///   - size     : view size in points (float2)
///   - progress : 1.0 = intact, 0.0 = fully burned (float)
///   - time     : elapsed seconds, drives fire animation (float)
///
/// The burn sweeps from **top → bottom** as `progress` decreases.
/// An FBM noise field perturbs the burn threshold, producing an organic,
/// flickering fire edge with a charcoal → deep-red → orange → yellow gradient.
[[stitchable]] half4 burnEffect(float2 position,
                                SwiftUI::Layer layer,
                                float2 size,
                                float  progress,
                                float  time) {
    float2 uv = position / size;

    // --- Animated noise displaces the horizontal burn edge ---
    float2 noiseCoord = float2(uv.x * 5.0 + time * 0.15,
                               uv.y * 5.0 + time * 0.10);
    float noiseVal = fbm(noiseCoord) * 0.14;

    // progress 1→0 maps burn threshold across the view top→bottom
    float threshold = (1.0 - progress) + noiseVal;
    float edgeWidth = 0.045;

    // --- Fully burned: transparent ---
    if (uv.y < threshold - edgeWidth) {
        return half4(0.0);
    }

    // --- Fire edge: charcoal → deep-red → orange → yellow ---
    if (uv.y < threshold) {
        float t = clamp((uv.y - (threshold - edgeWidth)) / edgeWidth, 0.0, 1.0);

        half3 charcoal = half3(0.05, 0.02, 0.00);
        half3 deepRed  = half3(0.80, 0.10, 0.00);
        half3 orange   = half3(1.00, 0.50, 0.00);
        half3 yellow   = half3(1.00, 0.95, 0.30);

        half3 col;
        if (t < 0.33) {
            col = mix(charcoal, deepRed, half(t / 0.33));
        } else if (t < 0.66) {
            col = mix(deepRed, orange, half((t - 0.33) / 0.33));
        } else {
            col = mix(orange,  yellow, half((t - 0.66) / 0.34));
        }

        float alpha = mix(0.0, 1.0, t);
        return half4(col * half(alpha), half(alpha));
    }

    // --- Unburned: sample original texture ---
    return layer.sample(position);
}
