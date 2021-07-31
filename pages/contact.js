import ContactRes from "src/pages/contact/Page_Contact";

export { getServerSideProps } from "src/pages/contact/Page_Contact_Server";

export default function Contact(props) {
  return <ContactRes {...props} />;
}
