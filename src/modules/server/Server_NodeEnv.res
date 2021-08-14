let isProduction = () => Server_Env.getNodeEnv() === "production"

let isDevelopment = () => Server_Env.getNodeEnv() === "development"
