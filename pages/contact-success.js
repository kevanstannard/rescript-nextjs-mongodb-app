import ContactSuccessRes from "src/pages/contact-success/Page_ContactSuccess";

export { getServerSideProps } from "src/pages/contact-success/Page_ContactSuccess_Server";

export default function ContactSuccess(props) {
  return <ContactSuccessRes {...props} />;
}
