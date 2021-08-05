import AboutRes from "src/pages/about/Page_About";

export { getServerSideProps } from "src/pages/about/Page_About_Server";

export default function About(props) {
  return <AboutRes {...props} />;
}
