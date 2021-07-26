module Icon = Component_Icon
module PasswordStrength = Component_PasswordStrength

module FormContainer = {
  @react.component
  let make = (~children) => {
    <div className="w-full md:w-3/4 lg:w-1/2 overflow-x-hidden"> {children} </div>
  }
}

module FieldErrorMessage = {
  @react.component
  let make = (~text: string) => {
    <div className="text-red-500 pt-2"> {React.string(text)} </div>
  }
}

module FieldHint = {
  @react.component
  let make = (~text: option<string>) => {
    switch text {
    | None => React.null
    | Some(text) => <div className="text-gray-500 text-sm mb-1"> {React.string(text)} </div>
    }
  }
}

module InputField = {
  type inputType = [#Email | #Text]

  let inputTypeAsString = type_ => {
    switch type_ {
    | #Email => "email"
    | #Text => "text"
    }
  }

  @react.component
  let make = (
    ~type_: inputType,
    ~label: string,
    ~value: string,
    ~onChange: string => unit,
    ~error: option<string>,
    ~hint: option<string>,
  ) => {
    <div className="mb-6">
      <label className="block mb-1">
        <div className="font-bold"> {React.string(label)} </div>
        <FieldHint text={hint} />
        <input
          type_={inputTypeAsString(type_)}
          className="bg-gray-100 border border-gray-300 p-2 w-full"
          value={value}
          onChange={(event: ReactEvent.Form.t) => {
            onChange(ReactEvent.Form.target(event)["value"])
          }}
        />
        {switch error {
        | None => React.null
        | Some(text) => <FieldErrorMessage text={text} />
        }}
      </label>
    </div>
  }
}

module TextField = {
  @react.component
  let make = (
    ~label: string,
    ~value: string,
    ~onChange: string => unit,
    ~error: option<string>,
    ~hint: option<string>=?,
  ) => {
    <InputField type_=#Text label value onChange error hint={hint} />
  }
}

module EmailField = {
  @react.component
  let make = (
    ~label: string,
    ~value: string,
    ~onChange: string => unit,
    ~error: option<string>,
    ~hint: option<string>=?,
  ) => {
    <InputField type_=#Email label value onChange error hint />
  }
}

module PasswordField = {
  @react.component
  let make = (
    ~label: string,
    ~value: string,
    ~onChange: string => unit,
    ~error: option<string>,
    ~showPasswordStrength: bool,
  ) => {
    let (showPassword, setShowPassword) = React.useState(() => false)
    <div className="mb-6">
      <button
        type_="button"
        tabIndex={-1}
        className="float-right"
        onClick={_event => {
          setShowPassword(_ => !showPassword)
        }}>
        {showPassword ? <Icon.EyeOff /> : <Icon.Eye />}
      </button>
      <label className="block mb-1">
        <div className="font-bold"> {React.string(label)} </div>
        <input
          type_={showPassword ? "text" : "password"}
          className="bg-gray-100 border border-gray-300 p-2 mb-1 w-full"
          value={value}
          onChange={(event: ReactEvent.Form.t) => {
            let value: string = ReactEvent.Form.target(event)["value"]
            onChange(value)
          }}
        />
        {showPasswordStrength ? <PasswordStrength password={value} /> : React.null}
        {switch error {
        | None => React.null
        | Some(text) => <FieldErrorMessage text={text} />
        }}
      </label>
    </div>
  }
}

module CheckboxField = {
  @react.component
  let make = (~label: string) => {
    <div className="mb-6">
      <label className="block">
        <input type_="checkbox" className="mr-2" /> {React.string(label)}
      </label>
    </div>
  }
}

module TextAreaField = {
  @react.component
  let make = (
    ~label: string,
    ~hint: option<string>=?,
    ~value: string,
    ~onChange: string => unit,
    ~error: option<string>,
  ) => {
    <div className="mb-6">
      <label className="block mb-1">
        <div className="font-bold"> {React.string(label)} </div>
        <FieldHint text={hint} />
        <textarea
          className="bg-gray-100 border border-gray-300 p-2 w-full h-40"
          value={value}
          onChange={(event: ReactEvent.Form.t) => {
            onChange(ReactEvent.Form.target(event)["value"])
          }}
        />
        {switch error {
        | None => React.null
        | Some(text) => <FieldErrorMessage text={text} />
        }}
      </label>
    </div>
  }
}

module ReCaptchaField = {
  @react.component
  let make = (~reCaptchaSiteKey, ~onChange, ~error) => {
    <div className="mb-7">
      <Component_ReCaptcha reCaptchaSiteKey={reCaptchaSiteKey} onChange />
      {switch error {
      | None => React.null
      | Some(text) => <FieldErrorMessage text={text} />
      }}
    </div>
  }
}

module ImageFileButton = {
  let getFile = event => {
    let fileList = event->Dom2.Event.currentTargetFiles
    if Dom2.FileList.length(fileList) === 1 {
      let file = Dom2.FileList.item(fileList, 0)
      Some(file)
    } else {
      None
    }
  }

  let readFileAsDataUrl = (file, callback) => {
    let reader = Dom2.FileReader.make()
    Dom2.FileReader.addEventListener(
      reader,
      #load,
      () => {
        let result = Dom2.FileReader.result(reader)
        callback(result)
      },
      false,
    )
    Dom2.FileReader.readAsDataUrl(reader, file)
  }

  let clearInput = (inputRef: React.ref<Js.Nullable.t<Dom.element>>) => {
    switch inputRef.current->Js.Nullable.toOption {
    | None => ()
    | Some(inputEl) => Dom2.Element.value(inputEl, "")
    }
  }

  @react.component
  let make = (~accept: string, ~label: string, ~onChange) => {
    let className =
      Component_Button.Styles.className(
        #Ready,
        #Gray,
        #Base,
        false,
      ) ++ " inline-block cursor-pointer mb-6"
    let inputRef = React.useRef(Js.Nullable.null)
    <label className={className}>
      {React.string(label)}
      <input
        ref={ReactDOM.Ref.domRef(inputRef)}
        type_="file"
        accept
        className="hidden"
        onChange={event => {
          let file = getFile(event)
          switch file {
          | None => onChange(None)
          | Some(file) =>
            readFileAsDataUrl(file, dataUrl => {
              let image = Dom2.Image.make()
              Dom2.Image.addEventListener(image, #load, _event => {
                onChange(Some((file, image, dataUrl)))
                clearInput(inputRef)
              })
              Dom2.Image.addEventListener(image, #error, _event => {
                onChange(None)
                clearInput(inputRef)
              })
              Dom2.Image.src(image, dataUrl)
            })
          }
        }}
      />
    </label>
  }
}
