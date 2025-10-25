// Continuous Fireworks
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

// Color palette for fireworks
vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.33, 0.67);
    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    vec2 uv = (gl_FragCoord.xy - u_resolution.xy * 0.5) / u_resolution.y;
    vec3 col = vec3(0.0); // Pure black background
    
    float t = u_time * 0.5;
    
    // Create many more fireworks with overlapping timing
    for(float i = 0.0; i < 12.0; i += 1.0) {
        float seed = i * 10.0;
        float explosionTime = mod(t + seed * 1.2, 4.5);
        
        float burstPhase = explosionTime; // 0 to 4.5
        float fade = smoothstep(0.0, 0.3, burstPhase) * (1.0 - smoothstep(3.5, 4.5, burstPhase));
        
        // Position for this firework 
        vec2 center = vec2(
            (hash(seed) - 0.5) * 0.6,
            (hash(seed + 1.0) - 0.5) * 0.4 + 0.2
        );
        
        vec2 p = uv - center;
        float angle = atan(p.y, p.x);
        float radius = length(p);
        
        // Pattern type - cycle through all 4 patterns
        float patternType = mod(i, 4.0);
        
        vec3 fireColor = palette(seed * 0.3 + t * 0.1);
        
        // Pattern 1: Circular burst
        if (patternType < 1.0) {
            for(float j = 0.0; j < 48.0; j += 1.0) {
                float rayAngle = (j / 48.0) * 6.28318;
                vec2 rayDir = vec2(cos(rayAngle), sin(rayAngle));
                float rayRadius = burstPhase * 0.4;
                vec2 particlePos = rayDir * rayRadius;
                
                float dist = length(p - particlePos);
                float sparkle = sin(t * 15.0 + j) * 0.5 + 0.5;
                
                if (dist < 0.015) {
                    float brightness = pow(1.0 - dist / 0.015, 3.0) * fade * sparkle;
                    col += fireColor * brightness * 1.2;
                }
            }
        }
        // Pattern 2: Spiral 
        else if (patternType < 2.0) {
            for(float j = 0.0; j < 64.0; j += 1.0) {
                float prog = j / 64.0;
                float spiralAngle = prog * 12.0 + burstPhase * 2.0;
                float spiralRadius = prog * burstPhase * 0.5;
                vec2 particlePos = vec2(cos(spiralAngle), sin(spiralAngle)) * spiralRadius;
                
                float dist = length(p - particlePos);
                if (dist < 0.012) {
                    float brightness = pow(1.0 - dist / 0.012, 3.0) * fade;
                    col += fireColor * brightness * 1.0;
                }
            }
        }
        // Pattern 3: Heart 
        else if (patternType < 3.0) {
            for(float j = 0.0; j < 80.0; j += 1.0) {
                float prog = (j / 80.0) * 6.28318;
                float r = burstPhase * 0.35;
                float x = r * pow(sin(prog), 3.0);
                float y = r * (0.8125 * cos(prog) - 0.3125 * cos(2.0 * prog) - 0.125 * cos(3.0 * prog));
                vec2 particlePos = vec2(x, y);
                
                float dist = length(p - particlePos);
                if (dist < 0.012) {
                    float brightness = pow(1.0 - dist / 0.012, 3.0) * fade;
                    col += vec3(1.0, 0.3, 0.6) * brightness * 1.2;
                }
            }
        }
        // Pattern 4: Ring burst
        else {
            for(float ring = 0.0; ring < 6.0; ring += 1.0) {
                float ringRadius = (ring / 6.0 + 0.3) * burstPhase * 0.4;
                float ringDist = abs(radius - ringRadius);
                
                if (ringDist < 0.008) {
                    float numDots = 32.0 + ring * 12.0;
                    float dotAngle = angle * numDots + t * 3.0;
                    float dotPattern = sin(dotAngle) * 0.5 + 0.5;
                    
                    if (dotPattern > 0.6) {
                        float brightness = pow(1.0 - ringDist / 0.008, 2.0) * fade * dotPattern;
                        col += fireColor * brightness * 1.0;
                    }
                }
            }
        }
        
        // Add glow at center
        float centerGlow = exp(-radius * 20.0) * fade * 0.8;
        col += fireColor * centerGlow;
    }
    
    // Add more twinkling stars
    vec2 starUV = uv * 30.0;
    vec2 starID = floor(starUV);
    vec2 starLocal = fract(starUV) - 0.5;
    float starHash = hash(dot(starID, vec2(12.9898, 78.233)));
    
    if (starHash > 0.97) {
        float starDist = length(starLocal);
        if (starDist < 0.05) {
            float twinkle = sin(t * 3.0 + starHash * 100.0) * 0.5 + 0.5;
            float starBright = pow(1.0 - starDist / 0.05, 4.0) * twinkle * 0.3;
            col += vec3(1.0) * starBright;
        }
    }
    
    gl_FragColor = vec4(col, 1.0);
}
