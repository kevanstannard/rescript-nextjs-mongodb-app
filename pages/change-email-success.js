import ChangeEmailSuccessRes from "src/pages/change-email-success/Page_ChangeEmailSuccess";

export { getServerSideProps } from "src/pages/change-email-success/Page_ChangeEmailSuccess_Server";

export default function ChangeEmailSuccess(props) {
  return <ChangeEmailSuccessRes {...props} />;
}
