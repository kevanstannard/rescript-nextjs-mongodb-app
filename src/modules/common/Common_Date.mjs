// Generated by ReScript, PLEASE EDIT WITH CARE

import Format from "date-fns/format";

var oneMinuteInMs = 1000.0 * 60.0;

var oneHourInMs = oneMinuteInMs * 60.0;

var oneDayInMs = oneHourInMs * 24.0;

function isInvalidDate(date) {
  return Number.isNaN(date.getTime());
}

function addDays(date, days) {
  var offset = days * oneDayInMs;
  return new Date(date.getTime() + offset);
}

function addHours(date, hours) {
  var offset = hours * oneHourInMs;
  return new Date(date.getTime() + offset);
}

function addMinutes(date, minutes) {
  var offset = minutes * oneMinuteInMs;
  return new Date(date.getTime() + offset);
}

function isInTheFuture(date) {
  var now = new Date().getTime();
  var other = date.getTime();
  return other > now;
}

function isInThePast(date) {
  return !isInTheFuture(date);
}

function formatDate(date) {
  return Format(date, "dd MMM yyyy");
}

var oneSecondInMs = 1000.0;

export {
  oneSecondInMs ,
  oneMinuteInMs ,
  oneHourInMs ,
  oneDayInMs ,
  isInvalidDate ,
  addDays ,
  addHours ,
  addMinutes ,
  isInTheFuture ,
  isInThePast ,
  formatDate ,
  
}
/* date-fns/format Not a pure module */
