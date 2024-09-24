uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;
uniform float uColorOffset;
uniform float uColorMultiplier;

varying float vElevation;
varying vec3 vNormal;
varying vec3 vFragPos;

// Includes
#include "../includes/ambientLight.glsl"
#include "../includes/directionalLight.glsl"
#include "../includes/pointLight.glsl"

void main()
{
    // Normalize the normals
    vec3 normal = normalize(vNormal);

    // New view direction
    vec3 viewDir = normalize(vFragPos - cameraPosition);

    // Base light
    vec3 light = vec3(0.0);

    // Base color
    float mixStrength = (vElevation + uColorOffset) * uColorMultiplier;
    mixStrength = smoothstep(0.0, 1.0, mixStrength);
    vec3 color = mix(uDepthColor, uSurfaceColor, mixStrength);

    // AMBIENT LIGHT - add it to the base light instance
    //light += ambientlight(
        //.5,             // intensity
        //vec3(1)      // color
    //);

    // DIRECTIONAL LIGHT
    vec3 dirLightColor = vec3(1.0);
    vec3 lightPos = vec3(0.0, 0.25, 0.0);
    float spec = 30.0;
    light += pointLight(
        dirLightColor, // Light color
        10.0, // Light intensity
        normal, // normals
        lightPos, // Light positionuuu
        viewDir, // Pos of camera
        spec, // power of the specular
        vFragPos,     // Position
        0.9
    );

    // add the final light to the color
    color *= light;

    // Final color
    //gl_FragColor = vec4(normal, 1.0);
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}
