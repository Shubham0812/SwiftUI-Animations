//
//  GlitchEffect.metal
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// --- Hash helpers ---
float glitchHash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

float glitchHash1(float x) {
    return fract(sin(x * 127.1) * 43758.5453);
}

// Digital corruption shader:
//   • Divides the image into horizontal bands that randomly shift left/right.
//   • Within each active band the RGB channels separate (chromatic split).
//   • Sparse bright scan-line flashes mimic hardware artefacts.
//
// `time`      – monotonically increasing seconds (drives discrete ticks).
// `intensity` – 0 = clean, 1 = heavy corruption.
[[ stitchable ]] half4 glitchEffect(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float time,
    float intensity
) {
    if (size.x == 0 || size.y == 0) { return layer.sample(position); }

    float2 uv   = position / size;

    // Quantise time into "ticks" so updates look chunky, not smooth
    float tick  = floor(time * 14.0);

    // --- Horizontal band setup ---
    float bandH = 0.06;                              // each band is 6% of height
    float band  = floor(uv.y / bandH);

    // Per-band random values keyed to (band, tick)
    float n1    = glitchHash(float2(band, tick));
    float n2    = glitchHash(float2(band * 0.5 + 7.3, tick + 1.0));
    float n3    = glitchHash(float2(band * 1.7 + 3.1, tick + 2.0));

    // Only a fraction of bands are active (controlled by intensity)
    float threshold = 1.0 - clamp(intensity * 0.45, 0.0, 0.45);
    float isActive  = step(threshold, n1);

    // --- Horizontal UV shift ---
    float maxShift   = 0.07 * intensity;
    float bandShift  = (n2 * 2.0 - 1.0) * maxShift * isActive;

    // --- RGB channel offsets (split within active bands) ---
    float rgbSplit   = 0.012 * intensity * isActive;

    float2 uvR = float2(fract(uv.x + bandShift + rgbSplit), uv.y);
    float2 uvG = float2(fract(uv.x + bandShift),            uv.y);
    float2 uvB = float2(fract(uv.x + bandShift - rgbSplit), uv.y);

    float r = layer.sample(uvR * size).r;
    float g = layer.sample(uvG * size).g;
    float b = layer.sample(uvB * size).b;
    float a = layer.sample(uvG * size).a;

    // --- Scan-line flash (rare bright horizontal streak) ---
    float flashTick    = floor(time * 20.0);
    float flashBand    = floor(uv.y / 0.02);          // finer bands for flashes
    float flashNoise   = glitchHash(float2(flashBand, flashTick));
    float flashActive  = step(0.96, flashNoise) * isActive;
    float flashBright  = flashActive * 0.35 * intensity;

    r = clamp(r + flashBright, 0.0, 1.0);
    g = clamp(g + flashBright, 0.0, 1.0);
    b = clamp(b + flashBright, 0.0, 1.0);

    // --- Noise grain on active bands ---
    float grain = (glitchHash(float2(uv * float2(size.x, size.y))) - 0.5) * 0.06 * intensity * isActive;
    r = clamp(r + grain, 0.0, 1.0);
    g = clamp(g + grain, 0.0, 1.0);

    return half4(half(r), half(g), half(b), half(a));
}
