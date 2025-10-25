// Fractal Noise Pattern
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

vec3 hsv(float h, float s, float v) {
    vec3 c = vec3(h);
    vec3 rgb = clamp(abs(mod(c + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    return v * mix(vec3(1.0), rgb, s);
}

void main() {
    vec2 FC = gl_FragCoord.xy;
    vec2 r = u_resolution;
    float t = u_time;
    vec4 o = vec4(0.0);
    
    float e = 0.0;
    float R = 0.0;
    float s = 4.0;  // Initialize s to 4.0
    vec3 q = vec3(0.0);
    vec3 p = vec3(0.0);
    vec3 d = vec3(FC.xy / r * 0.4 + vec2(-0.2, 0.8), 1.0);
    
    q.z = -1.0;
    q.y = -1.0;
    
    for(float i = 1.0; i < 100.0; i += 1.0) {
        float hue = mod(R - s / i, 6.0);
        o.rgb += 0.03 - hsv(hue * 0.5 + 5.0, 0.85, min(e * s * e, R) / 3.0);
        
        s = 4.0;
        p = (q += d * e * R * 0.1);
        
        R = length(p);
        p = vec3(
            log2(R + 0.001) - t * 0.5,  // Add small epsilon to avoid log(0)
            exp(R - p.z / (R + 0.001) * 0.1),
            atan(p.y + 0.05, p.x) * 2.0
        );
        
        p.y -= 1.0;
        e = p.y;
        
        // Manually unrolled: 4, 8, 16, 32, 64, 128, 256, 512
        float scale;
        scale = 4.0;
        e += dot(sin(p.xz * scale), sin(p.xx * scale + 0.5)) / scale;
        scale = 8.0;
        e += dot(sin(p.xz * scale), sin(p.xx * scale + 0.5)) / scale;
        scale = 16.0;
        e += dot(sin(p.xz * scale), sin(p.xx * scale + 0.5)) / scale;
        scale = 32.0;
        e += dot(sin(p.xz * scale), sin(p.xx * scale + 0.5)) / scale;
        scale = 64.0;
        e += dot(sin(p.xz * scale), sin(p.xx * scale + 0.5)) / scale;
        scale = 128.0;
        e += dot(sin(p.xz * scale), sin(p.xx * scale + 0.5)) / scale;
        scale = 256.0;
        e += dot(sin(p.xz * scale), sin(p.xx * scale + 0.5)) / scale;
        scale = 512.0;
        e += dot(sin(p.xz * scale), sin(p.xx * scale + 0.5)) / scale;
    }
    
    // Significantly boost the output
    o = o * 5.0 + 0.5;
    
    gl_FragColor = vec4(o.rgb, 1.0);
}
