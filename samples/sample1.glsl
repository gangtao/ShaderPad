// Cellular Wave Pattern
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

mat2 rotate2D(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat2(c, -s, s, c);
}

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
    vec4 o = vec4(0.0);
    float d = 0.0;
    
    for(float i = 1.0; i < 100.0; i++) {
        vec3 p = vec3((FC.xy * 2.0 - r.xy) / r.y * d, d - 9.0);
        p.yz *= rotate2D(-t / 3.0);
        
        float s = 0.004 + 0.07 * abs(1.0 - smoothstep(
            cos(dot(sin(ceil(p / 0.3)), cos(ceil(p / 0.6)).yzx)),
            length(p) - 4.0,
            0.4
        ) - i / 100.0);
        
        d += s;
        
        o.rgb += max(
            sin(vec3(1.0, 3.0, 0.0) * i * 0.7) / s,
            vec3(-length(p * p))
        );
    }
    
    o = tanh_approx(o * o / 1e6);
    gl_FragColor = vec4(o.rgb, 1.0);
}
