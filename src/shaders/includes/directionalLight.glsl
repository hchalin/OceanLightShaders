vec3 directionalLight(vec3 lightColor, float lightIntensity, vec3 normal, vec3 lightPos, vec3 viewDir, float specPow){
   // Light direction
    //vec3 lightDir = normalize(lightPos - vFragPos);

    // Halfway direction for specular component
    //vec3 halfDir = normalize(lightDir + viewDir);
    // or use reflection function built in
    //vec3 reflection = reflect(-lightDir, normal); // Gives you a reflected vector

    // Specular highlight calculation
    //float shininess = 16.0; // Increase for sharper highlights
    ////float spec = pow(max(dot(normal, halfDir), 0.0), shininess); // This looks better than below
    //float spec = pow(max(dot(normal, reflection), 0.0), shininess);

    // Diffuse reflection (Lambertian)
    //float hit = max(dot(normal, lightDir), 0.0);

    //return lightColor * lightIntensity * (hit + spec);

    // ----------- NEW ------
    // Light direction and reflection angle
    vec3 lightDir = normalize(lightPos);
    vec3 lightRef = reflect(-lightDir, normal);

    //shading
    float shading = dot(normal, lightDir);
    shading = max(0.0, shading);

    // Specular
    float spec = -dot(lightRef, viewDir);
    spec = max(0.0, spec); // dont let the dot go below 0
    spec = pow(spec, specPow);
    //return vec3(spec);

    //

    // Combine diffuse and specular contributions
    return lightColor * lightIntensity * (shading + spec);

}
