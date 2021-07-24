let getJson = (url: string) => {
  url->Fetch.fetchJson->Promise.then(Fetch.json)
}
