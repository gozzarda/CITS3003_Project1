#version 150

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out  vec4 position;
out  vec3 normal;
out  vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;

void main()
{
	position = vPosition;
	normal = vNormal;
    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
}
