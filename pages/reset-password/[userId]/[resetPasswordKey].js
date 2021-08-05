import ResetPasswordRes from "src/pages/reset-password/Page_ResetPassword";

export { getServerSideProps } from "src/pages/reset-password/Page_ResetPassword_Server";

export default function ResetPassword(props) {
  return <ResetPasswordRes {...props} />;
}
