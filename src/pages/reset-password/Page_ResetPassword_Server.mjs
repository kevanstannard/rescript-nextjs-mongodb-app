// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Common_User from "../../modules/common/Common_User.mjs";
import * as Server_Page from "../../modules/server/Server_Page.mjs";
import * as Server_User from "../../modules/server/Server_User.mjs";
import * as Server_Config from "../../modules/server/Server_Config.mjs";
import * as Server_Middleware from "../../modules/server/Server_Middleware.mjs";

function getServerSideProps(context) {
  return Server_Middleware.runAll(context.req, context.res).then(function (param) {
              var params = context.params;
              var match = Server_Middleware.getRequestData(context.req);
              var resetPasswordKey = params.resetPasswordKey;
              var userId = params.userId;
              var clientConfig = Server_Config.getClientConfig(undefined);
              var currentUserDto = Server_User.toNullCommonUserDto(match.currentUser);
              return Server_User.validateResetPasswordKey(match.client, userId, resetPasswordKey).then(function (validationResult) {
                          var resetPasswordError;
                          resetPasswordError = validationResult.TAG === /* Ok */0 ? undefined : Common_User.ResetPassword.refineResetPasswordKeyError(validationResult._0);
                          var resetPasswordErrors = {
                            resetPassword: resetPasswordError,
                            password: undefined,
                            passwordConfirm: undefined,
                            reCaptcha: undefined
                          };
                          var props_resetPasswordErrorsDto = Common_User.ResetPassword.resetPasswordErrorsToDto(resetPasswordErrors);
                          var props = {
                            config: clientConfig,
                            userDto: currentUserDto,
                            userId: userId,
                            resetPasswordKey: resetPasswordKey,
                            resetPasswordErrorsDto: props_resetPasswordErrorsDto
                          };
                          return Promise.resolve(Server_Page.props(props));
                        });
            });
}

export {
  getServerSideProps ,
  
}
/* Common_User Not a pure module */
