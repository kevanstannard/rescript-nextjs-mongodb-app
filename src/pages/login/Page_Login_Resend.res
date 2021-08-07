module AlertMessage = Component_AlertMessage
open Component_Button

type resendState =
  | ResendIdle
  | ResendIsResending
  | ResendSuccess
  | ResendError(Common_User.ResendActivation.errors)

@react.component
let make = (~email: string) => {
  let (state, setState) = React.useState(() => ResendIdle)

  let buttonState = switch state {
  | ResendIdle => #Ready
  | ResendIsResending => #Processing
  | ResendSuccess => #Ready
  | ResendError(_) => #Ready
  }

  let message = switch state {
  | ResendIdle => ""
  | ResendIsResending => "Resending activation email ..."
  | ResendSuccess => "Activation email was sent successfully."
  | ResendError(errors) => Common_User.ResendActivation.errorsToString(errors)
  }

  let onResend = () => {
    setState(_ => ResendIsResending)

    let onSuccess = (json: Js.Json.t) => {
      let {errors} = json->Common_User.ResendActivation.asResendActivationResult
      if Common_User.ResendActivation.hasErrors(errors) {
        setState(_ => ResendError(errors))
      } else {
        setState(_ => ResendSuccess)
      }
    }

    let onError = () => {
      let errors: Common_User.ResendActivation.errors = {
        resendActivation: Some(#RequestFailed),
      }
      setState(_ => ResendError(errors))
    }

    let resendActivation: Common_User.ResendActivation.resendActivation = {email: email}

    let errors = Common_User.ResendActivation.validateResendActivation(resendActivation)

    if Common_User.ResendActivation.hasErrors(errors) {
      setState(_ => ResendError(errors))
    } else {
      Client_User.resendActivationEmail(resendActivation, onSuccess, onError)->ignore
    }
  }

  <AlertMessage type_=#Info>
    <p className="mb-4"> {"Your account has not been activated."->React.string} </p>
    <p className="mb-4">
      <Button state={buttonState} size=#Small color=#Blue onClick={_ => onResend()}>
        {"Resend activation email?"->React.string}
      </Button>
    </p>
    <p> {message->React.string} </p>
  </AlertMessage>
}
