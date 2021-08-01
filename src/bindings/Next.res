module Req = {
  type t

  @set_index external set: (t, string, 'a) => unit = ""
  @get_index external get: (t, string) => Js.Nullable.t<'a> = ""
  @get_index external get_UNSAFE: (t, string) => 'a = ""
  @get external body: t => Js.Nullable.t<'a> = "body"
  @get external url: t => string = "url"
}

module Res = {
  type t

  // https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
  @set
  external statusCode: (
    t,
    @int
    [
      | @as(200) #Success
      | @as(400) #BadRequest
      | @as(403) #Forbidden
      | @as(404) #NotFound
      | @as(500) #ServerError
    ],
  ) => unit = "statusCode"

  @send external setHeader: (t, string, string) => unit = "setHeader"
  @send external sendJson: (t, Js.Json.t) => unit = "send"
  @send external sendString: (t, string) => unit = "send"
  @send external writeString: (t, string) => unit = "write"
  @send external endString: (t, string) => unit = "end"
  @send external end: t => unit = "end"
}

module GetServerSideProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params, 'previewData> = {
    params: 'params,
    query: Js.Dict.t<string>,
    preview: option<bool>, // preview is true if the page is in the preview mode and undefined otherwise.
    previewData: Js.Nullable.t<'previewData>,
    req: Req.t,
    res: Res.t,
  }

  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  // export type GetServerSidePropsResult<P> =
  // | { props: P }
  // | { redirect: Redirect }
  // | { notFound: true }

  type redirect = {
    destination: string,
    permanent: bool,
  }

  type result<'props> = {
    props: option<'props>,
    redirect: option<redirect>,
    notFound: option<bool>,
  }

  // The definition of a getServerSideProps function
  type t<'props, 'params, 'previewData> = context<'props, 'params, 'previewData> => Js.Promise.t<
    result<'props>,
  >
}

module GetStaticProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params, 'previewData> = {
    params: 'params,
    preview: option<bool>, // preview is true if the page is in the preview mode and undefined otherwise.
    previewData: Js.Nullable.t<'previewData>,
  }

  // The definition of a getStaticProps function
  type t<'props, 'params, 'previewData> = context<'props, 'params, 'previewData> => Js.Promise.t<{
    "props": 'props,
  }>
}

module GetStaticPaths = {
  // 'params: dynamic route params used in dynamic routing paths
  // Example: pages/[id].js would result in a 'params = { id: string }
  type path<'params> = {params: 'params}

  type return<'params> = {
    paths: array<path<'params>>,
    fallback: bool,
  }

  // The definition of a getStaticPaths function
  type t<'params> = unit => Js.Promise.t<return<'params>>
}

module Link = {
  @module("next/link") @react.component
  external make: (
    ~href: string,
    ~_as: string=?,
    ~prefetch: bool=?,
    ~replace: option<bool>=?,
    ~shallow: option<bool>=?,
    ~passHref: option<bool>=?,
    ~children: React.element,
  ) => React.element = "default"
}

module Router = {
  /*
      Make sure to only register events via a useEffect hook!
 */
  module Events = {
    type t

    @send
    external on: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "on"

    @send
    external off: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "off"
  }

  type router = {
    route: string,
    asPath: string,
    events: Events.t,
    pathname: string,
    query: Js.Dict.t<string>,
  }

  type pathObj = {
    pathname: string,
    query: Js.Dict.t<string>,
  }

  @send external push: (router, string) => unit = "push"
  @send external pushObj: (router, pathObj) => unit = "push"

  @module("next/router") external useRouter: unit => router = "useRouter"

  @send external replace: (router, string) => unit = "replace"
  @send external replaceObj: (router, pathObj) => unit = "replace"
}

module Head = {
  @module("next/head") @react.component
  external make: (~children: React.element) => React.element = "default"
}

// https://nextjs.org/docs/advanced-features/custom-error-page#reusing-the-built-in-error-page
module Error = {
  @module("next/error") @react.component
  external make: (
    ~statusCode: @int
    [
      | @as(400) #BadRequest
      | @as(403) #Forbidden
      | @as(404) #NotFound
      | @as(500) #ServerError
    ],
    ~title: string=?,
  ) => React.element = "default"
}

module Dynamic = {
  @deriving(abstract)
  type options = {
    @optional
    ssr: bool,
    @optional
    loading: unit => React.element,
  }

  @module("next/dynamic")
  external dynamic: (unit => Js.Promise.t<'a>, options) => 'a = "default"

  @val external import_: string => Js.Promise.t<'a> = "import"
}
