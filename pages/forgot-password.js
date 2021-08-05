import ForgotPasswordRes from "src/pages/forgot-password/Page_ForgotPassword";

export { getServerSideProps } from "src/pages/forgot-password/Page_ForgotPassword_Server";

export default function ForgotPassword(props) {
  return <ForgotPasswordRes {...props} />;
}
