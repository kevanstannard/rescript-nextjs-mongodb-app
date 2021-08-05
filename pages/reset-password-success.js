import ResetPasswordSuccessRes from "src/pages/reset-password-success/Page_ResetPasswordSuccess";

export { getServerSideProps } from "src/pages/reset-password-success/Page_ResetPasswordSuccess_Server";

export default function ResetPasswordSuccess(props) {
  return <ResetPasswordSuccessRes {...props} />;
}
