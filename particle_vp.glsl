#version 400

// Vertex buffer
in vec3 vertex;
in vec3 normal;
in vec3 color;

// Uniform (global) buffer
uniform mat4 world_mat;
uniform mat4 view_mat;
uniform mat4 normal_mat;
uniform float timer;

// Attributes forwarded to the geometry shader
out vec3 vertex_color;
out float timestep;

// Simulation parameters (constants)
uniform vec3 up_vec = vec3(0.0, 1.0, 0.0);
uniform vec3 object_color;

float grav = 0.45; // Gravity
float speed = 2.5; // Allows to control the speed of the explosion


void main()
{

	float lifetime = 2.0+color.g;
    // Let time cycle every four seconds
    float circtime = timer - lifetime * floor(timer / lifetime);
    float t = circtime; // Our time parameter
    
    // Let's first work in model space (apply only world matrix)
    vec4 position = world_mat * vec4(vertex, 1.0);
    vec4 norm = normal_mat * vec4(normal, 1.0);

    // Move point along normal and down with t*t (acceleration under gravity)
    position.x += norm.x*t*speed - grav*speed*up_vec.x*t*t;
    position.y += norm.y*t*speed - grav*speed*up_vec.y*t*t;
    position.z += norm.z*t*speed - grav*speed*up_vec.z*t*t;
    
    // Now apply view transformation
    gl_Position = view_mat * position;
        
    // Define outputs
    // Define color of vertex
    //vertex_color = color.rgb; // Color defined during the construction of the particles
    //vertex_color = object_color; // Uniform color 
    //vertex_color = vec3(t, 0.0, 1-t);
    vertex_color = vec3(object_color.x-t, object_color.y-t, object_color.z-t);

    // Forward time step to geometry shader
    timestep = t;
}
