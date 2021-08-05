module AlertMessage = Component_AlertMessage
open Component_Button

type resendState =
  | ResendIdle
  | ResendIsResending
  | ResendSuccess
  | ResendError(Common_User.ResendActivation.resendActivationError)

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
  | ResendError(error) => Common_User.ResendActivation.resendActivationErrorToString(error)
  }

  let onResend = () => {
    setState(_ => ResendIsResending)

    let onSuccess = (json: Js.Json.t) => {
      let resendResult = json->Common_User.ResendActivation.asResendActivationResult
      switch resendResult.error {
      | None => setState(_ => ResendSuccess)
      | Some(error) => setState(_ => ResendError(error))
      }
    }

    let onError = () => {
      setState(_ => ResendError(#RequestFailed))
    }

    let resendActivation: Common_User.ResendActivation.resendActivation = {email: email}

    let error = Common_User.ResendActivation.validateResendActivation(resendActivation)

    switch error {
    | Some(error) => setState(_ => ResendError(error))
    | None => Client_User.resendActivationEmail(resendActivation, onSuccess, onError)->ignore
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
