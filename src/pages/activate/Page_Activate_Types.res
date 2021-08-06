type params = {
  userId: string,
  activationKey: string,
}

// `props` must only contain valid JSON types (no undefined values)
type props = {
  userDto: Js.Null.t<Common_User.User.dto>,
  activationSuccessful: bool,
}
