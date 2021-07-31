import SignupRes from "src/pages/signup/Page_Signup";

// This can be re-exported as is (no Fast-Refresh issues)
export { getServerSideProps } from "src/pages/signup/Page_Signup_Server";

// Note:
// We need to wrap the make call with
// a Fast-Refresh conform function name,
// (in this case, uppercased first letter)
//
// If you don't do this, your Fast-Refresh will
// not work!
export default function Signup(props) {
  return <SignupRes {...props} />;
}
