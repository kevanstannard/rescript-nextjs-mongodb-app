import ForgotPasswordSuccessRes from "src/pages/forgot-password-success/Page_ForgotPasswordSuccess";

export { getServerSideProps } from "src/pages/forgot-password-success/Page_ForgotPasswordSuccess_Server";

export default function ForgotPasswordSuccess(props) {
  return <ForgotPasswordSuccessRes {...props} />;
}
