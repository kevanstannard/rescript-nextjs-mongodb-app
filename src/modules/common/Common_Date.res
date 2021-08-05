// https://stackoverflow.com/questions/6963311/add-days-to-a-date-object

let oneSecondInMs = 1000.0
let oneMinuteInMs = oneSecondInMs *. 60.0
let oneHourInMs = oneMinuteInMs *. 60.0
let oneDayInMs = oneHourInMs *. 24.0

let isInvalidDate = date => date->Js.Date.getTime->Js.Float.isNaN

let addDays = (date: Js.Date.t, days: int) => {
  let offset = Js.Int.toFloat(days) *. oneDayInMs
  Js.Date.fromFloat(Js.Date.getTime(date) +. offset)
}

let addHours = (date: Js.Date.t, hours: int) => {
  let offset = Js.Int.toFloat(hours) *. oneHourInMs
  Js.Date.fromFloat(Js.Date.getTime(date) +. offset)
}

let addMinutes = (date: Js.Date.t, minutes: int) => {
  let offset = Js.Int.toFloat(minutes) *. oneMinuteInMs
  Js.Date.fromFloat(Js.Date.getTime(date) +. offset)
}

let isInTheFuture = (date: Js.Date.t) => {
  let now = Js.Date.make()->Js.Date.getTime
  let other = date->Js.Date.getTime
  other > now
}

let isInThePast = (date: Js.Date.t) => {
  !isInTheFuture(date)
}

let formatDate = date => {
  DateFns.format(date, "dd MMM yyyy")
}
