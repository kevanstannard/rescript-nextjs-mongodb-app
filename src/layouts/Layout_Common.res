// TODO: https://evilmartians.com/chronicles/how-to-favicon-in-2021-six-files-that-fit-most-needs

module Link = Component_Link
module HtmlEntity = Component_HtmlEntity
module ContentContainer = Component_ContentContainer
module Icon = Component_Icon

module Header = {
  let getHeaderLinks = user => {
    switch user {
    | None => [
        ("Home", Common_Url.home(), None),
        ("Contact", Common_Url.contact(), None),
        ("Sign up", Common_Url.signup(), None),
        ("Log in", Common_Url.login(), None),
        ("Github", Common_Url.github(), Some(#Svg("/static/octocat.svg"))),
      ]
    | Some(_) => [
        ("Home", Common_Url.home(), None),
        ("Contact", Common_Url.contact(), None),
        ("Account", Common_Url.account(), None),
        ("Log out", Common_Url.logout(), None),
        ("Github", Common_Url.github(), Some(#Svg("/static/octocat.svg"))),
      ]
    }
  }

  module MobileIcon = {
    module OpenMenuButton = {
      @react.component
      let make = (~title, ~onClick) => {
        <button title type_="button" onClick={onClick}>
          <Icon.Menu color=#Black size=#Large />
        </button>
      }
    }

    module CloseMenuButton = {
      @react.component
      let make = (~title, ~onClick) => {
        <button title type_="button" onClick={onClick}>
          <Icon.X color=#Black size=#Large />
        </button>
      }
    }

    @react.component
    let make = (~menuIsOpen, ~setMenuIsOpen) => {
      menuIsOpen
        ? <CloseMenuButton title="Close menu" onClick={_ => setMenuIsOpen(_ => false)} />
        : <OpenMenuButton title="Open menu" onClick={_ => setMenuIsOpen(_ => true)} />
    }
  }

  module DesktopMenu = {
    @react.component
    let make = (~user) => {
      <div>
        {getHeaderLinks(user)
        ->Js.Array2.map(((name, url, icon)) => {
          let icon = switch icon {
          | None => React.null
          | Some(icon) =>
            switch icon {
            | #Png(url) => <img className="inline-block h-6" src=url />
            | #Svg(url) => <img className="inline-block h-6" src=url />
            }
          }
          <a key=name href={url} className="font-medium hover:bg-gray-100 p-2 mr-2 rounded">
            {icon} {React.string(name)}
          </a>
        })
        ->React.array}
      </div>
    }
  }

  // TODO: For the mobile menu, make the whole row clickable rather than just the text
  module MobileMenu = {
    @react.component
    let make = (~user) => {
      <div>
        {getHeaderLinks(user)
        ->Js.Array2.map(((name, url, icon)) => {
          let icon = switch icon {
          | None => React.null
          | Some(icon) =>
            switch icon {
            | #Png(url) => <img className="inline-block h-6" src=url />
            | #Svg(url) => <img className="inline-block h-6" src=url />
            }
          }
          <div
            key={name}
            className="py-2 px-4 bg-gray-200 font-medium hover:bg-gray-300 text-right border-b border-white">
            <ContentContainer> <a href={url}> {icon} {React.string(name)} </a> </ContentContainer>
          </div>
        })
        ->React.array}
      </div>
    }
  }

  @react.component
  let make = (~user: option<Common_User.User.t>) => {
    let (menuIsOpen, setMenuIsOpen) = React.useState(_ => false)
    let border = menuIsOpen ? "" : "border-b border-gray-200"
    <div className={`mb-8 ${border}`}>
      <div className="py-2 lg:py-6">
        <ContentContainer>
          <div className="flex items-center justify-between">
            <h1>
              <a
                href={Common_Url.home()}
                className="flex items-center font-bold text-xl xlg:text-2xl">
                <img className="w-5 mr-2" src="/static/zeit-black-triangle.svg" />
                {React.string("ReScript + NextJS + MongoDB")}
              </a>
            </h1>
            <div>
              <div className="hidden lg:block"> <DesktopMenu user /> </div>
              <div className="lg:hidden"> <MobileIcon menuIsOpen setMenuIsOpen /> </div>
            </div>
          </div>
        </ContentContainer>
      </div>
      <div className="lg:hidden"> {menuIsOpen ? <MobileMenu user /> : React.null} </div>
    </div>
  }
}

module Footer = {
  @react.component
  let make = () => {
    <div className="py-4">
      <hr className="mb-4" />
      <ContentContainer>
        <div className="flex">
          <div className="w-1/2 text-sm md:text-base">
            <HtmlEntity code="copy" /> {React.string(" 2021 Pixel Papercraft")}
          </div>
          <div className="w-1/2 text-sm md:text-base text-right">
            <Link href={Common_Url.privacy()}> {"Privacy Policy"->React.string} </Link>
          </div>
        </div>
      </ContentContainer>
    </div>
  }
}
