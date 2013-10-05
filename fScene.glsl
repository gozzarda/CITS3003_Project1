#version 150

in  vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
in  vec4 position;
in  vec3 normal;

out vec4 fColor;

vec4 color;

uniform sampler2D texture;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform vec4 LightPosition;
uniform float Shininess;
uniform float texScale;
uniform vec4 Light2Position;
uniform vec3 Light1rgbBright;
uniform vec3 Light2rgbBright;
uniform float spread; //[TFD]: light1's spotsize, I don't like my variable names.
uniform vec4 lightRot;	//[TFD]: the direction that light1 is pointing in.

void
main()
{    
	// Transform vertex position into eye coordinates
    vec3 pos = (ModelView * position).xyz;


    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
	vec3 L2 = normalize( Light2Position.xyz );	// Negated direction of light from Light 2 (parallel source)
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector
	vec3 H2 = normalize( L2 + E );

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = Light1rgbBright * AmbientProduct;
	vec3 ambient2 = Light2rgbBright * AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Light1rgbBright * Kd*DiffuseProduct;
	float Kd2 = max( dot(L2, N), 0.0 );
    vec3  diffuse2 = Light2rgbBright * Kd2*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Light1rgbBright * Ks * SpecularProduct;
	float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    vec3  specular2 = Light2rgbBright * Ks2 * SpecularProduct;

	// [TFD]: PART J. Light has no effect on fragments outside cone of spotlight
	if(dot(L,normalize(lightRot.xyz)) < spread){ // [TFD]: if the fragment is not in the cone of light
		ambient = vec3(0.0, 0.0, 0.0);
		diffuse = vec3(0.0, 0.0, 0.0);
		specular = vec3(0.0, 0.0, 0.0);
	}
    
    if( dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 
	if( dot(L2, N) < 0.0 ) {
	specular2 = vec3(0.0, 0.0, 0.0);
    }

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
	float dropoff = sqrt(dot(Lvec, Lvec))/15 + 1;
    color.rgb = ((ambient + diffuse) / dropoff) + globalAmbient + ambient2 + diffuse2;	// [GOZ]: PART F. Light due to Light 1 drops off like 1/(R/15 + 1)
	// [TFD]: PART H. Specular is seperate from color. 
	// [GOZ]: Light due to light 2 does not drop off
    color.a = 1.0;

    fColor = (color * texture2D( texture, texCoord * 2.0 * texScale )) + vec4( specular / dropoff + specular2, 1.0 );
	// [TFD]: PART H. Spec does not depend on texture
	// [TFD]: PART J. texScale scales texCoord. larger texScale=>smaller texture
}
