type jsonResponse

@val external fetchJson: string => Promise.t<jsonResponse> = "fetch"
@send external json: jsonResponse => Promise.t<'a> = "json"
