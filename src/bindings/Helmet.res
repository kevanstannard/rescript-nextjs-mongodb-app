// Helmet is middleware that sets various security related headers.
// See: https://helmetjs.github.io/

module ContentSecurityPolicy = {
  // Helmet provides a default collection content security policy directives:
  //
  // default-src 'self';
  // base-uri 'self';
  // block-all-mixed-content;
  // font-src 'self' https: data:;
  // frame-ancestors 'self';
  // img-src 'self' data:;
  // object-src 'none';
  // script-src 'self';
  // script-src-attr 'none';
  // style-src 'self' https: 'unsafe-inline';
  // upgrade-insecure-requests
  //
  // Reference:
  // https://github.com/helmetjs/helmet#reference
  @module("helmet") @scope("contentSecurityPolicy")
  external getDefaultDirectives: unit => {..} = "getDefaultDirectives"

  type makeOptions = {
    scriptSrc: option<array<string>>,
    scriptSrcElem: option<array<string>>,
    frameSrc: option<array<string>>,
  }

  let make = ({scriptSrc, scriptSrcElem, frameSrc}: makeOptions) => {
    let directives = getDefaultDirectives()
    switch scriptSrc {
    | None => ()
    | Some(scriptSrc) => directives["script-src"] = scriptSrc
    }
    switch scriptSrcElem {
    | None => ()
    | Some(scriptSrcElem) => directives["script-src-elem"] = scriptSrcElem
    }
    switch frameSrc {
    | None => ()
    | Some(frameSrc) => directives["frame-src"] = frameSrc
    }
    {
      "directives": directives,
    }
  }
}

// Helpet provides connect style middleware which is compatible with NextConnect.
// See: https://github.com/senchalabs/connect
@module("helmet")
external middleware_: {..} => NextConnect.middleware = "default"

type options = {
  frameSrc: option<array<string>>,
  scriptSrc: option<array<string>>,
  scriptSrcElem: option<array<string>>,
}

let middleware = (options: options) => {
  let contentSecurityPolicy = ContentSecurityPolicy.make({
    scriptSrc: options.scriptSrc,
    scriptSrcElem: options.scriptSrcElem,
    frameSrc: options.frameSrc,
  })
  let options = {
    "contentSecurityPolicy": contentSecurityPolicy,
  }
  middleware_(options)
}
