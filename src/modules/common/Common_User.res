// The _id field in database objects have an ObjectId type
// The _id field everywhere else needs to be a string
type user<'a> = {
  _id: 'a,
  email: string,
  emailVerified: bool,
  password: string,
}

type commonUser = user<string>

type clientUser = {
  id: string,
  email: string,
}
