import AccountRes from "src/pages/account/Page_Account";

export { getServerSideProps } from "src/pages/account/Page_Account_Server";

export default function Account(props) {
  return <AccountRes {...props} />;
}
