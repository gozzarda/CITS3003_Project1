#version 150

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

	//[TFD]: part D.A1
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
	//[TFD]: part D.A2
	mat4 boneTransform = boneWeights[0] * boneTransforms[boneIDs[0]]	+
						 boneWeights[1] * boneTransforms[boneIDs[1]]	+
						 boneWeights[2] * boneTransforms[boneIDs[2]]	+
						 boneWeights[3] * boneTransforms[boneIDs[3]];

	//[TFD]: part D.A3, 4th element of vNormal should be 0, as with normalTransform
	vec4 positionTransform = boneTransform * vPosition;
	vec3 normalTransform = mat3 ( boneTransform ) * vNormal;
	
	position = positionTransform;
	normal = normalTransform;
    gl_Position = Projection * ModelView * positionTransform;
    texCoord = vTexCoord;
}
