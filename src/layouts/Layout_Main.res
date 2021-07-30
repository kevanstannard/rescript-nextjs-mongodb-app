module Link = Next.Link

module Navigation = {
  @react.component
  let make = () =>
    <nav className="p-2 h-12 flex border-b border-gray-200 justify-between items-center text-sm">
      <Link href="/">
        <a className="flex items-center">
          <img className="w-5" src="/static/zeit-black-triangle.svg" />
          <span className="text-xl ml-2 align-middle font-semibold">
            {React.string("Next + MongoDB + ReScript")}
          </span>
        </a>
      </Link>
      <div className="flex justify-end">
        <Link href="/"> <a className="px-3"> {React.string("Home")} </a> </Link>
        <Link href="/login"> <a className="px-3"> {React.string("Login")} </a> </Link>
        <Link href="/signup"> <a className="px-3"> {React.string("Signup")} </a> </Link>
      </div>
    </nav>
}

@react.component
let make = (~children) => {
  let minWidth = ReactDOM.Style.make(~minWidth="20rem", ())
  <div style=minWidth className="flex lg:justify-center">
    <div className="max-w-5xl w-full lg:w-3/4 text-gray-900 font-base">
      <Navigation /> <main className="mt-4 mx-4"> children </main>
    </div>
  </div>
}
