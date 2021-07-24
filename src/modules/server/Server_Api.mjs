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

export {
  sendJson ,
  
}
/* No side effect */
