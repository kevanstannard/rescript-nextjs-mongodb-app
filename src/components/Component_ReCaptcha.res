let prepare: (~id: string, ~siteKey: string, ~onChange: string => unit) => string = %raw(`
  function init(id, siteKey, onChange) {
    var onLoadName = "reCaptchaOnLoad";
    var onDoneName = "reCaptchaOnDone";

    window[onLoadName] = function() {
      grecaptcha.render(id, {
        sitekey: siteKey,
        callback: onDoneName
      });
    };

    window[onDoneName] = onChange;

    var url = "https://www.google.com/recaptcha/api.js?onload=" + onLoadName + "&render=explicit";

    return url;
  }
`)

let reCaptchaId = "reCaptcha"

@react.component
let make = (~reCaptchaSiteKey, ~onChange) => {
  let (isLoaded, setIsLoaded) = React.useState(() => false)
  React.useEffect0(() => {
    if !isLoaded {
      let url = prepare(~id=reCaptchaId, ~siteKey=reCaptchaSiteKey, ~onChange)
      Client_Script.loadScript(. url, _ => (), _ => ())
      setIsLoaded(_ => true)
    }
    None
  })
  <div id={reCaptchaId} />
}
