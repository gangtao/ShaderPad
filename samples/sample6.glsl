// Fractal Noise Pattern
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

// HSV to RGB color conversion
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
    
    float e = 0.0;     // Accumulated noise value
    float R = 0.0;     // Radius/distance
    float s = 5.0;     // Scale for noise octaves
    vec3 q = vec3(0.0); // Accumulated position
    vec3 p = vec3(0.0); // Transformed position
    
    // Ray direction calculation
    // (FC.xy-r)/r normalizes screen coordinates to -1..1
    // *.2 scales it down
    // +vec2(.1,1.5) offsets for interesting camera angle
    vec3 d = vec3((FC.xy - r) / r * 0.2 + vec2(0.1, 1.5), 1.0);
    
    // Initialize q (starting position offset)
    q.z = -1.0;
    q.y = -1.0;
    
    // Main raymarching loop - 75 iterations
    for(float i = 1.0; i < 75.0; i += 1.0) {
        // Color calculation using HSV color space
        // Fixed hue = 0.6 (cyan/blue tones)
        // Saturation varies with e/i (noise pattern)
        // Value based on position and accumulated noise
        float hue = 0.6;
        float saturation = e / i;
        float value = min(e * s - q.z, R) / 6.0;
        
        // Accumulate color (0.03 base, subtract HSV result)
        o.rgb += 0.03 - hsv(hue, saturation, value);
        
        // Reset scale for inner loop
        s = 5.0;
        
        // Update position along ray
        // d * e * R * 0.13 is the step size
        q += d * e * R * 0.13;
        p = q;
        
        // Transform to logarithmic/polar coordinates
        // Scale by 0.7, then calculate radius
        R = length(p * 0.7);
        
        // Apply coordinate transformations:
        // x: logarithmic radial distance with time animation
        // y: exponential based on z-coordinate
        // z: angular coordinate (atan)
        p = vec3(
            log2(R) - t * 0.1,        // Logarithmic spiral with time
            exp2(R - p.z / R),         // Exponential decay
            atan(p.y, p.x)            // Polar angle
        );
        
        // Decrement y and use as initial noise value
        p.y -= 1.0;
        e = p.y;
        
        // Multi-octave noise accumulation
        // Original: for(e=--p.y;s<2e3;s+=s)e+=dot(cos(p*s),sin(p.xyx*s+5.))/s*.6
        // Manually unrolled: 5, 10, 20, 40, 80, 160, 320, 640, 1280
        
        // Each iteration:
        // - cos(p*s): oscillating pattern at frequency s
        // - sin(p.xyx*s+5.): swizzled oscillation with phase offset
        // - dot(): combines x,y,z components
        // - /s: scale by frequency (higher frequencies contribute less)
        // - *.6: damping factor
        
        float scale;
        
        scale = 5.0;
        e += dot(cos(p * scale), sin(p.xyx * scale + 5.0)) / scale * 0.6;
        
        scale = 10.0;
        e += dot(cos(p * scale), sin(p.xyx * scale + 5.0)) / scale * 0.6;
        
        scale = 20.0;
        e += dot(cos(p * scale), sin(p.xyx * scale + 5.0)) / scale * 0.6;
        
        scale = 40.0;
        e += dot(cos(p * scale), sin(p.xyx * scale + 5.0)) / scale * 0.6;
        
        scale = 80.0;
        e += dot(cos(p * scale), sin(p.xyx * scale + 5.0)) / scale * 0.6;
        
        scale = 160.0;
        e += dot(cos(p * scale), sin(p.xyx * scale + 5.0)) / scale * 0.6;
        
        scale = 320.0;
        e += dot(cos(p * scale), sin(p.xyx * scale + 5.0)) / scale * 0.6;
        
        scale = 640.0;
        e += dot(cos(p * scale), sin(p.xyx * scale + 5.0)) / scale * 0.6;
        
        scale = 1280.0;
        e += dot(cos(p * scale), sin(p.xyx * scale + 5.0)) / scale * 0.6;
    }
    
    // Boost output brightness for visibility
    o = o * 3.0;
    
    gl_FragColor = vec4(o.rgb, 1.0);
}
