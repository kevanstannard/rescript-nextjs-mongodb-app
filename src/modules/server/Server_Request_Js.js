export function getData(req) {
  return req.__DATA;
}

export function get(req, key) {
  if (req.__DATA) {
    return req.__DATA[key] || null;
  }
  return null;
}

export function set(req, key, value) {
  if (!req.__DATA) {
    req.__DATA = {};
  }
  req.__DATA[key] = value;
}
