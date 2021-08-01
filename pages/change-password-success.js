import ChangePasswordSuccessRes from "src/pages/change-password-success/Page_ChangePasswordSuccess";

export { getServerSideProps } from "src/pages/change-password-success/Page_ChangePasswordSuccess_Server";

export default function ChangePasswordSuccess(props) {
  return <ChangePasswordSuccessRes {...props} />;
}
