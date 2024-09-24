vec3 pointLight(vec3 lightColor, float lightIntensity, vec3 normal, vec3 lightPos, vec3 viewDir, float specPow,
                vec3 position, float lightDecay){

    // Light direction and reflection angle
    vec3 lightDelta = lightPos - position;
    float lightDist = length(lightDelta);
    vec3 lightDir = normalize(lightDelta);
    vec3 lightRef = reflect(-lightDir, normal);

    //shading
    float shading = dot(normal, lightDir);
    shading = max(0.0, shading);

    // Specular
    float spec = -dot(lightRef, viewDir);
    spec = max(0.0, spec); // dont let the dot go below 0
    spec = pow(spec, specPow);

    // Decay
    float decay = 1.0 - lightDist * lightDecay;
    decay = max(0.0, decay);            // Dont let it go below 0

    // Combine diffuse and specular contributions
    return lightColor * lightIntensity * decay * (shading + spec);

}
