#version 150

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out  vec4 position;
out  vec3 normal;
out  vec2 texCoord;


void main()
{
	position = vPosition;
	normal = vNormal;
    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
}
