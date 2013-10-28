#version 150

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

	//[TFD]: A1 of addingAnimation.txt
in ivec4 boneIDs;
in  vec4 boneWeights;
uniform mat4 boneTransforms[64];

out  vec4 position;
out  vec3 normal;
out  vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;


void main()
{
	//[TFD]: A2 of addingAnimation.txt
	mat4 boneTransform = boneWeights[0] * boneTransforms[boneIDs[0]];

	for(int i = 1; i < 64; i++) {
		boneTransform += boneWeights[0] * boneTransforms[boneIDs[0]];
	}

	//[TFD]: A3: transformed variables used instead of vposition and vnormal
	vec4 positionTransform = boneTransform * vPosition;
	vec4 normalTransform = boneTransform * vNormal;
	
	position = positionTransform;
	normal = normalTransform;
    gl_Position = Projection * ModelView * positionTransform;
    texCoord = vTexCoord;
}
