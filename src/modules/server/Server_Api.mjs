// Generated by ReScript, PLEASE EDIT WITH CARE


function sendJson(res, code, payload) {
  res.statusCode = (function () {
        switch (code) {
          case "Success" :
              return 200;
          case "BadRequest" :
              return 400;
          case "Forbidden" :
              return 403;
          case "NotFound" :
              return 404;
          case "ServerError" :
              return 500;
          
        }
      })();
  res.send(payload);
  
}

function sendError(res, code, error) {
  var payload = {
    error: error
  };
  return sendJson(res, code, payload);
}

export {
  sendJson ,
  sendError ,
  
}
/* No side effect */
