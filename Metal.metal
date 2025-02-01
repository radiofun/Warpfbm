//
//  Metal.metal
//  SwiftJan31
//
//  Created by Minsang Choi on 2/1/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;


float random (float2 st) {
    return fract(sin(dot(st.xy,
                         float2(12.9898,78.233)))
                 * 43758.5453123);
}


float noise (float2 st) {
    float2 i = floor(st);
    float2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + float2(1.0, 0.0));
    float c = random(i + float2(0.0, 1.0));
    float d = random(i + float2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    float2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}


[[ stitchable ]] half4 fbm(float2 position, SwiftUI::Layer l, float4 boundingRect, float2 c, float time, float octaves) {
    
    float2 size = float2(boundingRect[2],boundingRect[3]);
    float2 uv = position / size;
    float2 center = c / size;
    float distance = length(uv-center);

    float lacunarity = 8.0;
    float gain = 0.5;
    
    int oct = int(octaves);
    
    float amplitude = 0.5;
    float frequency = 1.;
    
    for (int i = 0; i < oct; i++) {
        uv.x += amplitude * noise(frequency*uv.y) * sin(time * 0.01 * distance) * 0.01;
        uv.y *= amplitude * noise(frequency*uv.x) * tan(time * 1.20 * (distance* 0.09));
        frequency *= lacunarity;
        amplitude *= gain;
    }
    

    float2 offset = (uv - center) * 2;
    
    half3 color = half3(l.sample(uv * size + offset).r, l.sample(uv * size).g, l.sample(uv * size - offset).b);
    
    
    return half4(color,1);
}

