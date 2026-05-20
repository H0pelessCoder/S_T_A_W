shader_type canvas_item;
render_mode blend_mix;
// -- uniforms (you can tweak these in the inspector) --
uniform float AA_FALLOFF = 1.2;
uniform float GRID_WIDTH = 0.1;
uniform float CURVE_WIDTH = 10.0;
uniform float FUNC_SAMPLE_STEP = 0.25;
uniform float SCOPE_RATE = 0.5;
uniform vec4 BACK_GROUND_COLOR1:source_color = vec4(0.1,0.25,0.35,1.0);
uniform vec4 BACK_GROUND_COLOR2:source_color = vec4(0.02,0.05,0.07,1.0);
uniform vec4 PULSE_COLOR:source_color = vec4(0.0, 1.0, 0.7,1.0);
uniform float HEART_PULSE_RATE:hint_range(0.0, 5.0, 0.01) = 0.5;
uniform float HEART_PULSE_STRENGTH:hint_range(0.0, 2.0, 0.01) = 0.5;
// built‑in uniforms and inputs:
//   UV               - interpolated texture UV coordinates
//   TEXTURE_PIXEL_SIZE - size of one pixel in UV space
//   TIME             - elapsed time in seconds

varying float pp;

// sinc helper
float sinc(float x) {
    return (abs(x) < 1e-6) ? 1.0 : sin(x) / x;
}

// triangular window
float triIsolate(float x) {
    return abs(-1.0 + fract(clamp(x, -0.5, 0.5)) * 2.0);
}

// heartbeat wave
float heartbeat(float x) {
    float pre = -sinc((x - 0.4) * 20.0) * 0.6 * triIsolate((x - 0.4) * 1.0);
    float main = sinc((x - 0.5) * 60.0) * 1.2 * triIsolate((x - 0.5) * 0.7);
    float post = sinc((x - 0.85) * 15.0) * 0.5 * triIsolate((x - 0.85) * 0.6);
    return (pre + main + post) * triIsolate((x - 0.625) * 0.8);
}
//float heartbeat(float x) {
    //// sharpened pre-beat pulse
    //float pre = -sinc((x - 0.0) * 100.0) * 0.8 * triIsolate((x - 0.4) * 1.5);
    //// boosted main spike with narrower window
    //float main = sinc((x - 0.5) * 80.0) * 1.5 * triIsolate((x - 0.5) * 0.5);
    //// intensified post-beat echo
    //float post = sinc((x - 0.95) * -90.0) * 0.7 * triIsolate((x - 0.85) * 0.4);
    //// final envelope slightly widened
    //return (pre + main + post) * triIsolate((x - 0.625) * 1.2);
//}

// the function to plot
float func(float x) {
    return HEART_PULSE_STRENGTH * heartbeat(mod(x * HEART_PULSE_RATE + 0.25, 1.3));
}

// linear AA step
float aaStep(float a, float b, float x) {
    x = clamp(x, a, b);
    return (x - a) / (b - a);
}

// alpha‑blend helper
void blend(inout vec4 baseCol, vec4 col, float alpha) {
    baseCol = vec4(mix(baseCol.rgb, col.rgb, alpha * col.a), 1.0);
}

// draw grid lines every stepSize in graph‑space
void drawGrid(inout vec4 baseCol, vec2 xy, float stepSize, vec4 color) {
    float hlw = GRID_WIDTH * pp * 0.5;
    float mul = 1.0 / stepSize;
    vec2 gf = abs(-0.5 + fract((xy + vec2(stepSize) * 0.5) * mul));
    float g = 1.0 - aaStep(hlw*mul, (hlw + pp*AA_FALLOFF)*mul, min(gf.x, gf.y));
    blend(baseCol, color, g);
}

// draw the function curve
void drawFunc(inout vec4 baseCol, vec2 xy, vec4 curveCol) {
    float hlw = CURVE_WIDTH * pp * 0.5;
    float left = xy.x - hlw - pp*AA_FALLOFF;
    float right = xy.x + hlw + pp*AA_FALLOFF;
    float closest = 1e6;
    for (float x = left; x <= right; x += pp * FUNC_SAMPLE_STEP) {
        vec2 diff = vec2(x, func(x)) - xy;
        closest = min(closest, dot(diff, diff));
    }
    float c = 1.0 - aaStep(0.0, hlw + pp*AA_FALLOFF, sqrt(closest));
    blend(baseCol, curveCol, c*c*c);
}

// draw a circle at the sweep point
void drawCircle(inout vec4 baseCol, vec2 xy, vec2 center, float radius, vec4 color) {
    float r = length(xy - center);
    float c = 1.0 - aaStep(0.0, radius + pp*AA_FALLOFF, r);
    blend(baseCol, color, c*c);
}

// vertex stage: compute pixel pitch in graph units
void vertex() {
    // derive screen resolution in UV-space
    vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE;
    // compute graph size same as fragment
    float aspect = resolution.x / resolution.y;
    float graphRange = 0.4; // static
    vec2 graphSize = vec2(aspect * graphRange, graphRange);
    // pixel pitch = graph-space units per fragment pixel
    pp = graphSize.y * TEXTURE_PIXEL_SIZE.y;
}

void fragment() {
    // use UV directly
    vec2 uv = UV;

    // derive screen resolution in UV-space for centering
    vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE;
    float aspect = resolution.x / resolution.y;
    float graphRange = 1.5;
    vec2 graphSize = vec2(aspect * graphRange, graphRange);
    vec2 graphCenter = vec2(0.2, 0.0);
    vec2 graphPos = graphCenter - graphSize * 0.5;

    // map to graph‑space
    vec2 xy = graphPos + uv * graphSize;

    // background gradient
    float t = length(0.5 - uv) * 1.414;
    t = pow(t, 3.0);
    vec4 col = mix(BACK_GROUND_COLOR1, BACK_GROUND_COLOR2, t);

    // draw grids
    drawGrid(col, xy, 0.1, vec4(1.0,1.0,1.0,0.1));
    drawGrid(col, xy, 0.5, vec4(1.0,1.0,1.0,0.1));
    drawGrid(col, xy, 1.0, vec4(1.0,1.0,1.0,0.4));

    // determine scope sweep rate
    float rate = SCOPE_RATE;

    // compute pulse position & fade (use built-in TIME)
    float pulse = fract(TIME * rate) * 4.0 - 1.5;
    float fade = pulse - xy.x;
    if (fade < 0.0) fade += 4.0;
    fade = clamp((fade * 0.25) / rate, 0.0, 1.0);
    fade = pow(1.0 - fade, 3.0);

    vec4 pulseCol = vec4(PULSE_COLOR.r, PULSE_COLOR.g, PULSE_COLOR.b, fade * 1.5);
    drawFunc(col, xy, pulseCol);

    // draw moving highlight circle
    pulseCol.a = 1.5;
    drawCircle(col, xy, vec2(pulse, func(pulse)), CURVE_WIDTH * pp, pulseCol);

    COLOR = col;
	COLOR.a *= (1.0 - t);
}
