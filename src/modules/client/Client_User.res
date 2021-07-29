let signup = (signup: Common_User.Signup.signup, onSuccess, onError) => {
  Client_Xhr.post(
    ~url="/api/signup",
    ~body=Json(signup->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}
