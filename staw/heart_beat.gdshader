shader_type canvas_item;

uniform float health_pct : hint_range(0.0, 1.0) = 1.0;
uniform float scan_speed = 0.5;
uniform float thickness = 0.015;     // Thickness of the trail line
uniform float ball_size = 0.04;      // Size of the leading round dot
uniform float frequency = 8.0;
uniform float amplitude = 0.3;
uniform float trail_length = 0.6; 

void fragment() {
    // We use a triangle wave for those sharp hospital peaks
    float line_shape = abs(fract(UV.x * frequency) - 0.5) * 2.0;
    float pulse = (0.5 - line_shape) * amplitude;
    float y_pos = 0.5 + pulse;
    
    // Locate the Scanning Head (The Dot's position)
    float scan_x = fract(TIME * scan_speed);
    // To get the Dot's Y, we sample the wave logic at the scan_x position
    float dot_line_shape = abs(fract(scan_x * frequency) - 0.5) * 2.0;
    float scan_y = 0.5 + (0.5 - dot_line_shape) * amplitude;

    //Create the Round Ball (Circular distance)
    float dist_to_ball = distance(UV, vec2(scan_x, scan_y));
    float ball_mask = smoothstep(ball_size, ball_size - 0.01, dist_to_ball);

    
    float line_dist = abs(UV.y - y_pos);
    float line_mask = step(line_dist, thickness);
    
    float trail_factor = fract(scan_x - UV.x);
    float trail_fade = pow(1.0 - trail_factor, 10.0 / trail_length);
    
    // Clean up trail so it doesn't wrap around incorrectly
    if (trail_factor > trail_length) { trail_fade = 0.0; }
    
    float final_line = line_mask * trail_fade;


    vec3 health_color;
    if (health_pct > 0.7) {
        health_color = vec3(0.0, 1.0, 1.0); // Green
    } else if (health_pct > 0.4) {
        health_color = vec3(0.5, 0.75, 1.0); // Yellow
    } else if (health_pct > 0.2) {
        health_color = vec3(0.0, 0.5, 1.0); // Orange
    } else {
        health_color = vec3(0.0, 0.0, 1.0); // Red
    }

    //Combine Ball and Line
    // We make the ball slightly brighter (add some white) to make it "pop"
    vec3 ball_color = health_color + vec3(0.7); 
    
    float mask = max(final_line, ball_mask);
    vec3 final_color = mix(health_color, ball_color, ball_mask);

    COLOR = vec4(final_color, mask);
}