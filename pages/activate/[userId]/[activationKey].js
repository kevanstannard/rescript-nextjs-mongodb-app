import ActivateRes from "src/pages/activate/Page_Activate.mjs";

export { getServerSideProps } from "src/pages/activate/Page_Activate_Server.mjs";

export default function Activate(props) {
  return <ActivateRes {...props} />;
}
