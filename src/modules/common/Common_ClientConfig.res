type reCaptcha = {siteKey: string}

// Important: This is sent from server to client,
// so must only contain valid JSON values (no undefined values)
type t = {reCaptcha: reCaptcha}
