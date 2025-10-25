// Bitdumb - Fractal Grid Zoom (Working)
#ifdef GL_OES_standard_derivatives
#extension GL_OES_standard_derivatives : enable
#endif

precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

void main() {
    vec2 FC = gl_FragCoord.xy;
    vec2 r = u_resolution;
    float t = u_time;
    vec3 col = vec3(0.0);
    
    // Initialize position - center and normalize
    vec2 p = (FC.xy - 0.5 * r) / r.y;
    
    // Fractal zoom loop - 20 iterations
    for(float i = 1.0; i < 21.0; i += 1.0) {
        // Ceil the position to create grid
        vec2 v = ceil(p);
        
        // Calculate grid lines using fract
        vec2 grid = abs(fract(p) - 0.5);
        float line = min(grid.x, grid.y);
        
        // Make lines visible when close to grid boundaries
        float thickness = 0.05 / i; // Thinner at higher iterations
        float edge = smoothstep(thickness, 0.0, line);
        
        // Animated alpha based on distance and time
        float dist = length(v);
        float wave = fract(dist / i - t * 0.2);
        
        // Color based on iteration and animation
        vec3 iterColor = 0.5 + 0.5 * cos(i * 0.5 + vec3(0.0, 1.0, 2.0));
        
        // Add grid lines with animated brightness
        col += edge * iterColor * wave * 0.3;
        
        // Double the position for fractal zoom
        p = p * 2.0;
    }
    
    // Clamp to prevent over-brightness
    col = clamp(col, 0.0, 1.0);
    
    gl_FragColor = vec4(col, 1.0);
}
