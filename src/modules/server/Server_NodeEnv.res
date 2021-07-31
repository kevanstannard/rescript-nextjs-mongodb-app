let isProduction = () => {
  switch Server_Env.getNodeEnv() {
  | "production" => true
  | "development" => false
  | "test" => false
  | _ => Js.Exn.raiseError("Unknown environment")
  }
}
