# ShaderPad
Real-time GLSL Shader Playground


ShaderPad is a browser-based tool for writing, testing, and experimenting with GLSL fragment shaders in real-time. No setup required - just write shader code and see the results instantly.

![ShaderPad Interface](https://img.shields.io/badge/WebGL-Powered-blue)


### Requirements

- Modern web browser with WebGL support (Chrome, Firefox, Safari, Edge)
- No installation or build tools needed!

## Usage

### Available Uniforms

ShaderPad automatically provides these uniforms in your shaders:

```glsl
uniform float u_time;       // Time in seconds since start
uniform vec2 u_resolution;  // Canvas resolution in pixels
uniform vec2 u_mouse;       // Mouse position (x, y)
```

### Basic Example

```glsl
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    vec3 col = 0.5 + 0.5 * cos(u_time + uv.xyx + vec3(0, 2, 4));
    gl_FragColor = vec4(col, 1.0);
}
```


### Built-in Examples

ShaderPad includes several example shaders to help you get started:

1. **Wave Pattern** - Cellular raymarching effect with organic motion
2. **Plasma** - Classic animated plasma effect
3. **Mandelbrot** - Interactive fractal visualization
4. **Tunnel** - 3D tunnel effect with polar coordinates

## Tips & Tricks

### Performance Optimization

- Use `lowp` or `mediump` precision when `highp` isn't necessary
- Minimize loop iterations for better performance
- Profile using the FPS counter in the info panel


### WebGL Compatibility

ShaderPad uses WebGL 1.0 and is compatible with:
- Chrome 56+
- Firefox 52+
- Safari 11+
- Edge 79+

### Shader Language

- **Language**: GLSL ES 1.0 (OpenGL ES Shading Language)
- **Precision**: highp float recommended
- **Fragment shader only** - vertex shader is handled automatically

### Known Limitations

- Only fragment shaders are supported (no custom vertex shaders)
- Some GLSL functions may not be available in WebGL 1.0
- Performance varies based on shader complexity and hardware

## Examples

### Simple Gradient

```glsl
precision highp float;
uniform vec2 u_resolution;

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    gl_FragColor = vec4(uv.x, uv.y, 0.5, 1.0);
}
```

### Animated Circle

```glsl
precision highp float;
uniform vec2 u_resolution;
uniform float u_time;

void main() {
    vec2 uv = (gl_FragCoord.xy - u_resolution * 0.5) / u_resolution.y;
    float d = length(uv) - 0.3 - sin(u_time) * 0.1;
    vec3 col = d < 0.0 ? vec3(1.0, 0.5, 0.2) : vec3(0.1);
    gl_FragColor = vec4(col, 1.0);
}
```

### Interactive (Mouse-based)

```glsl
precision highp float;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    vec2 mouse = u_mouse / u_resolution.xy;
    float d = distance(uv, mouse);
    vec3 col = vec3(smoothstep(0.1, 0.0, d));
    gl_FragColor = vec4(col, 1.0);
}
```


## Resources

### Learning GLSL

- [The Book of Shaders](https://thebookofshaders.com/) - Excellent GLSL tutorial
- [Shadertoy](https://www.shadertoy.com/) - Community shader showcase
- [WebGL Fundamentals](https://webglfundamentals.org/) - WebGL tutorials
- [GLSL Sandbox](http://glslsandbox.com/) - Another shader playground

### Inspiration

- [Inigo Quilez](https://iquilezles.org/) - Legendary shader artist and tutorials
- [Shadertoy Gallery](https://www.shadertoy.com/results?query=sort%3Dpopular) - Amazing shader examples