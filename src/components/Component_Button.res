open Component_Icon

type buttonState = [#Ready | #Disabled | #Processing]
type buttonColor = [#None | #LightGray | #Gray | #Green | #Blue | #Red]
type buttonSize = [#Base | #Small]

let getDisabled = state => {
  switch state {
  | #Ready => false
  | #Disabled => true
  | #Processing => true
  }
}

let getContent = (state, children) => {
  switch state {
  | #Ready => children
  | #Disabled => children
  | #Processing => <ProgressSpin color=#White />
  }
}

// TODO: Deprecated. Use Component_ButtonStyles
module Styles = {
  let getColor = (style: buttonColor, state: buttonState) => {
    switch style {
    | #None =>
      switch state {
      | #Ready => "bg-transparent"
      | #Disabled => "bg-transparent"
      | #Processing => "bg-transparent"
      }
    | #LightGray =>
      switch state {
      | #Ready => "bg-gray-400 hover:bg-gray-300"
      | #Disabled => "bg-gray-200"
      | #Processing => "bg-gray-200"
      }
    | #Gray =>
      switch state {
      | #Ready => "bg-gray-500 hover:bg-gray-400"
      | #Disabled => "bg-gray-200"
      | #Processing => "bg-gray-200"
      }
    | #Green =>
      switch state {
      | #Ready => "bg-green-500 hover:bg-green-400"
      | #Disabled => "bg-gray-300"
      | #Processing => "bg-gray-300"
      }
    | #Blue =>
      switch state {
      | #Ready => "bg-blue-500 hover:bg-blue-400"
      | #Disabled => "bg-gray-300"
      | #Processing => "bg-gray-300"
      }
    | #Red =>
      switch state {
      | #Ready => "bg-red-500 hover:bg-red-400"
      | #Disabled => "bg-gray-300"
      | #Processing => "bg-gray-300"
      }
    }
  }

  let getSize = (size: buttonSize) => {
    switch size {
    | #Base => "text-base py-4 px-6"
    | #Small => "text-sm py-2 px-4"
    }
  }

  let getFull = full => full ? "w-full" : ""

  let className = (state, color, size, full) =>
    "text-white text-center font-semibold rounded" ++
    " " ++
    getSize(size) ++
    " " ++
    getColor(color, state) ++
    " " ++
    getFull(full)
}

module Button = {
  @react.component
  let make = (
    ~state: buttonState,
    ~onClick: ReactEvent.Mouse.t => unit,
    ~color: buttonColor=#Gray,
    ~size: buttonSize=#Base,
    ~full: bool=false,
    ~title: string="",
    ~children: React.element,
  ) => {
    let className = Styles.className(state, color, size, full)
    <button
      title type_="button" className={className} disabled={getDisabled(state)} onClick={onClick}>
      {getContent(state, children)}
    </button>
  }
}

module IconButton = {
  module Icon = Component_Icon

  let makeIcon = icon => {
    switch icon {
    | #ChevronDown => <Icon.ChevronDown color=#White />
    | #ChevronUp => <Icon.ChevronUp color=#White />
    | #ChevronDoubleDown => <Icon.ChevronDoubleDown color=#White />
    | #ChevronDoubleUp => <Icon.ChevronDoubleUp color=#White />
    | #Menu => <Icon.Menu color=#White />
    | #Trash => <Icon.Trash color=#White />
    | #X => <Icon.X color=#White />
    }
  }

  @react.component
  let make = (~title, ~onClick, ~icon, ~color, ~state) => {
    <Button title onClick color state size=#Small> {makeIcon(icon)} </Button>
  }
}
