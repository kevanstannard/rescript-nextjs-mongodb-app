type params = {
  userId: string,
  emailChangeKey: string,
}

type props = {
  userDto: Js.Null.t<Common_User.User.dto>,
  emailChangeSuccessful: bool,
}
