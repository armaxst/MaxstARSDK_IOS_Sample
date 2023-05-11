//
//  MetalFunction.metal
//  MetalTest
//
//  Created by Kimseunglee on 2017. 9. 21..
//  Copyright © 2017년 Maxst. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    packed_float3 position;
    packed_float4 color;
    packed_float2 texCoord;
};

typedef struct {
    float3x3 matrix;
    float3 offset;
} ColorConversion;


struct VertexOut {
    float4 position [[position]];
    float4 color;
    float2 texCoord;
};

struct Uniforms {
    float4x4 modelViewProjectionMatrix;
};

vertex VertexOut texture_vertex_func(constant VertexIn *vertices [[buffer(0)]], constant Uniforms &uniforms [[buffer(1)]], uint vid [[vertex_id]]) {
    float4x4 matrix = uniforms.modelViewProjectionMatrix;
    VertexIn in = vertices[vid];
    VertexOut out;
    out.position = matrix * float4(in.position, 1);
    out.texCoord = in.texCoord;
    return out;
}

fragment float4 texture_fragment_func(VertexOut vert [[stage_in]], texture2d<float> tex2D [[ texture(0) ]], sampler sampler2D [[ sampler(0) ]]) {
    float4 color = tex2D.sample(sampler2D, vert.texCoord);
    float gamma = 0.5;
    
    float3 rgb = float3(color.r, color.g, color.b);
    rgb = pow(rgb, float3(1.0/gamma));
    
    return float4(float3(rgb), 1.0);
}

vertex VertexOut video_vertex_func(constant VertexIn *vertices [[buffer(0)]], constant Uniforms &uniforms [[buffer(1)]], uint vid [[vertex_id]]) {
    float4x4 matrix = uniforms.modelViewProjectionMatrix;
    VertexIn in = vertices[vid];
    VertexOut out;
    out.position = matrix * float4(in.position, 1);
    out.texCoord = in.texCoord;
    return out;
}

fragment half4 video_fragment_func(VertexOut in [[stage_in]],
                                   
                                   texture2d<float, access::sample> textureY [[ texture(0) ]],
                                   
                                   texture2d<float, access::sample> textureCbCr [[ texture(1) ]],
                                   
                                   constant ColorConversion &colorConversion [[ buffer(0) ]]) {
    
    
    
    constexpr sampler s(address::clamp_to_edge, filter::linear);
    
    float3 ycbcr = float3(textureY.sample(s, in.texCoord).r, textureCbCr.sample(s, in.texCoord).rg);
    
    float gamma = 0.5;
    
    float3 rgb = colorConversion.matrix * (ycbcr + colorConversion.offset);
    
    rgb = pow(rgb, float3(1.0/gamma));
    
    return half4(half3(rgb), 1.0);
    
}

vertex VertexOut color_vertex_func(constant VertexIn *vertices [[buffer(0)]], constant Uniforms &uniforms [[buffer(1)]], uint vid [[vertex_id]]) {
    float4x4 matrix = uniforms.modelViewProjectionMatrix;
    VertexIn in = vertices[vid];
    VertexOut out;
    out.position = matrix * float4(in.position, 1);
    out.color = in.color;
    return out;
}

fragment float4 color_fragment_func(VertexOut vert [[stage_in]]) {
    float4 color = vert.color;
    return color;
}


