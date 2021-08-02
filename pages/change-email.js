import ChangeEmailRes from "src/pages/change-email/Page_ChangeEmail";

export { getServerSideProps } from "src/pages/change-email/Page_ChangeEmail_Server";

export default function ChangeEmail(props) {
  return <ChangeEmailRes {...props} />;
}
