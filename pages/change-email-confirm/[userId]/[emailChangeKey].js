import ChangeEmailConfirmRes from "src/pages/change-email-confirm/Page_ChangeEmailConfirm";

export { getServerSideProps } from "src/pages/change-email-confirm/Page_ChangeEmailConfirm_Server";

export default function ChangeEmailConfirm(props) {
  return <ChangeEmailConfirmRes {...props} />;
}
