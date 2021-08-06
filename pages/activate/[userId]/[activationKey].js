import ActivateRes from "src/pages/activate/Page_Activate";

export { getServerSideProps } from "src/pages/activate/Page_Activate_Server";

export default function Activate(props) {
  return <ActivateRes {...props} />;
}
