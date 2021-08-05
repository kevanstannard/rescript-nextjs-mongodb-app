let getHeaderLinks = user => {
  switch user {
  | None => [
      ("Home", Common_Url.home()),
      ("Contact", Common_Url.contact()),
      ("Sign up", Common_Url.signup()),
      ("Log in", Common_Url.login()),
    ]
  | Some(_) => [
      ("Home", Common_Url.home()),
      ("Contact", Common_Url.contact()),
      ("Account", Common_Url.account()),
      ("Log out", Common_Url.logout()),
    ]
  }
}

module Navigation = {
  @react.component
  let make = (~user: option<Common_User.User.t>) => {
    <nav className="p-2 h-12 flex border-b border-gray-200 justify-between items-center text-sm">
      <Next.Link href="/">
        <a className="flex items-center">
          <img className="w-5" src="/static/zeit-black-triangle.svg" />
          <span className="text-xl ml-2 align-middle font-semibold whitespace-nowrap">
            {React.string("ReScript + NextJS + MongoDB")}
          </span>
        </a>
      </Next.Link>
      <div className="flex justify-end">
        {getHeaderLinks(user)
        ->Belt.Array.map(((name, url)) => {
          <Next.Link key={url} href={url}>
            <a className="px-3"> {React.string(name)} </a>
          </Next.Link>
        })
        ->React.array}
      </div>
    </nav>
  }
}

@react.component
let make = (~user: option<Common_User.User.t>, ~children) => {
  let minWidth = ReactDOM.Style.make(~minWidth="20rem", ())
  <div style=minWidth className="flex lg:justify-center">
    <div className="max-w-5xl w-full lg:w-3/4 text-gray-900 font-base">
      <Navigation user={user} /> <main className="mt-4 mx-4"> children </main>
    </div>
  </div>
}
