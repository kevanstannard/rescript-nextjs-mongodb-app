import PrivacyRes from "src/pages/privacy/Page_Privacy";

export { getServerSideProps } from "src/pages/privacy/Page_Privacy_Server";

export default function Privacy(props) {
  return <PrivacyRes {...props} />;
}
