module Signup = {
  type signup = {
    email: string,
    password: string,
    reCaptcha: option<string>,
  }
}
