import ChangePasswordRes from "src/pages/change-password/Page_ChangePassword";

export { getServerSideProps } from "src/pages/change-password/Page_ChangePassword_Server";

export default function ChangePassword(props) {
  return <ChangePasswordRes {...props} />;
}
