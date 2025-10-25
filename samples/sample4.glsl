// Aperture/Tunnel Effect - Expanded with Comments
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

// tanh approximation for tone mapping
vec4 tanh_approx(vec4 x) {
    vec4 x2 = x * x;
    vec4 x3 = x2 * x;
    vec4 x5 = x3 * x2;
    return x - x3 / 3.0 + x5 * 2.0 / 15.0;
}

void main() {
    vec2 FC = gl_FragCoord.xy;
    vec2 r = u_resolution;
    float t = u_time;
    vec4 o = vec4(0.0);  // Output color accumulator
    
    vec3 p = vec3(0.0);  // Ray position in 3D
    float d = 0.0;       // Distance to surface
    float z = 0.0;       // Depth/distance traveled
    
    // Raymarching loop - 100 iterations
    for(float i = 1.0; i < 100.0; i += 1.0) {
        // Calculate ray direction from screen space
        // normalize(FC.rgb*2.-r.xyy) becomes:
        vec3 rayDir = vec3(FC.xy * 2.0 - r.xy, r.y);
        p = z * normalize(rayDir);
        
        // Animate the tunnel by adjusting z based on time
        // Creates the forward motion effect
        p.z -= t - z * 0.6;
        
        // Distance field: abs(.03*z-.3)
        // Creates tunnel-like structure with variable width
        d = abs(0.03 * z - 0.3);
        
        // Complex distance field using cos transforms
        // max(p=cos(p),p.yzx) - applies cos, then takes max with swizzled version
        vec3 pCos = cos(p);        // Apply cosine to create ripples
        vec3 pSwizzle = pCos.yzx;  // Swizzle coordinates
        vec3 maxP = max(pCos, pSwizzle);  // Take maximum
        float lenMax = length(maxP);      // Calculate length
        
        // Combine distance fields: max(d, length(...) - d)
        d = max(d, lenMax - d);
        
        // Step forward by distance
        z += d;
        
        // Color accumulation
        // (cos(z*.3+vec4(0,1,2,0))+2.)/d/z
        // Creates rainbow colors that shift with depth
        vec4 colorWave = cos(z * 0.3 + vec4(0.0, 1.0, 2.0, 0.0)) + 2.0;
        vec4 colorContrib = colorWave / d / z;
        o += colorContrib;
    }
    
    // Tone mapping: tanh(o*o/9e2)
    // Compresses bright colors and adds contrast
    o = tanh_approx(o * o / 900.0);
    
    gl_FragColor = vec4(o.rgb, 1.0);
}
