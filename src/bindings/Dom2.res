module Element = {
  type t = Dom.element

  @set
  external value: (t, string) => unit = "value"
}

module Image = {
  type t = Dom.htmlImageElement

  @new
  external make: unit => t = "Image"

  @set
  external src: (t, string) => unit = "src"

  @send
  external addEventListener: (t, [#load | #error], Dom.event => unit) => unit = "addEventListener"

  @get external width: t => int = "width"
  @get external height: t => int = "height"
  @get external offsetWidth: t => int = "offsetWidth"
  @get external offsetHeight: t => int = "offsetHeight"
  @get external naturalWidth: t => int = "naturalWidth"
  @get external naturalHeight: t => int = "naturalHeight"
}

module File = {
  type t

  @get external name: t => string = "name"
  @get external size: t => int = "size" // bytes
  @get external type_: t => string = "type"
  @get external lastModified: t => int = "lastModified"
  @get external lastModifiedDate: t => Js.Date.t = "lastModifiedDate"
}

module FileList = {
  type t

  @get
  external length: t => int = "length"

  @send
  external item: (t, int) => File.t = "item"
}

module FileReader = {
  type t
  type dataUrl = string

  type listenEvent = [#load]

  @new
  external make: unit => t = "FileReader"

  @send
  external addEventListener: (t, listenEvent, unit => unit, bool) => unit = "addEventListener"

  @send
  external readAsDataUrl: (t, File.t) => unit = "readAsDataURL"

  @get
  external result: t => dataUrl = "result"
}

module Event = {
  type t = ReactEvent.Form.t

  let currentTarget = ReactEvent.Form.currentTarget

  let currentTargetFiles = (event: t): FileList.t => ReactEvent.Form.currentTarget(event)["files"]
}

module FormData = {
  type t

  @new external make: unit => t = "FormData"
  @send external append: (t, string, 'a) => unit = "append"
}
