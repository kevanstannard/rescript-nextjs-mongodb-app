// Generated by ReScript, PLEASE EDIT WITH CARE


function getColor(color, state) {
  if (color === "Red") {
    if (state === "Disabled" || state !== "Ready") {
      return "bg-gray-300";
    } else {
      return "bg-red-500 hover:bg-red-400";
    }
  } else if (color === "Blue") {
    if (state === "Disabled" || state !== "Ready") {
      return "bg-gray-300";
    } else {
      return "bg-blue-500 hover:bg-blue-400";
    }
  } else if (color === "Green") {
    if (state === "Disabled" || state !== "Ready") {
      return "bg-gray-300";
    } else {
      return "bg-green-500 hover:bg-green-400";
    }
  } else if (color === "Gray") {
    if (state === "Disabled" || state !== "Ready") {
      return "bg-gray-200";
    } else {
      return "bg-gray-500 hover:bg-gray-400";
    }
  } else if (color === "None") {
    return "bg-transparent";
  } else if (state === "Disabled" || state !== "Ready") {
    return "bg-gray-200";
  } else {
    return "bg-gray-400 hover:bg-gray-300";
  }
}

function getSize(size) {
  if (size === "Base") {
    return "text-base py-4 px-6";
  } else {
    return "text-sm py-2 px-4";
  }
}

function getFull(full) {
  if (full) {
    return "w-full";
  } else {
    return "";
  }
}

function makeClassName(state, color, size, full) {
  return "text-white text-center font-semibold rounded " + getSize(size) + " " + getColor(color, state) + " " + (
          full ? "w-full" : ""
        );
}

export {
  getColor ,
  getSize ,
  getFull ,
  makeClassName ,
  
}
/* No side effect */
