module Title = Component_Title

@react.component
let make = (~user: option<Common_User.User.t>, ~html: string) => {
  <Layout_Main user={user}>
    <Title text="Privacy Policy" size=#Primary />
    <p className="pb-4"> {React.string("Updated: 1 January 2021")} </p>
    <div className="prose mb-8" dangerouslySetInnerHTML={{"__html": html}} />
  </Layout_Main>
}
