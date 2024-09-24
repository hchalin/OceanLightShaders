uniform float uTime;
uniform float uBigWavesElevation;
uniform vec2 uBigWavesFrequency;
uniform float uBigWavesSpeed;

uniform float uSmallWavesElevation;
uniform float uSmallWavesFrequency;
uniform float uSmallWavesSpeed;
uniform float uSmallIterations;

varying float vElevation;
varying vec3 vFragPos;
varying vec3 vNormal;

// Include cnoise
#include "../includes/perlinClassic3D.glsl"

float createElevation(vec3 position){

    // Elevation
    float elevation = sin(position.x * uBigWavesFrequency.x + uTime * uBigWavesSpeed) *
                      sin(position.z * uBigWavesFrequency.y + uTime * uBigWavesSpeed) *
                      uBigWavesElevation;

    for(float i = 1.0; i <= uSmallIterations; i++)
    {
        elevation -= abs(perlinClassic3D(vec3(position.xz * uSmallWavesFrequency * i, uTime * uSmallWavesSpeed)) * uSmallWavesElevation / i);
    }

    return elevation;


}

void main()
{
    // Base position
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    /**
        NEIGHBORS TECHNIQUE
    */
    // shift
    float shift = 0.01;
                // Neighboring vertices
    vec3 a = modelPosition.xyz + vec3(shift, 0.0, 0.0);
    vec3 b = modelPosition.xyz + vec3(0.0, 0.0, - shift);

    // Elevation
    float elevation = createElevation(modelPosition.xyz);
    modelPosition.y += elevation;
    a.y += createElevation(a);
    b.y += createElevation(b);

    // Calculate normals
    vec3 toA = normalize(a - modelPosition.xyz);
    vec3 toB = normalize(b - modelPosition.xyz);
    vec3 computeNormal = cross(toA, toB);

    // Final position
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;


    // Update the normals
    vec4 modelNormal = modelMatrix * vec4(normal, 0.0);

    // Varyings
    vElevation = elevation;
    vFragPos = modelPosition.xyz;
    vNormal = computeNormal;

}
