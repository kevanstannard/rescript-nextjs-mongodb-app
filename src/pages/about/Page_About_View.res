module Title = Component_Title

@react.component
let make = (~user: option<Common_User.User.t>, ~html: string) => {
  <Layout_Main user={user}>
    <Title text="About this site" size=#Primary />
    <div className="prose mb-8" dangerouslySetInnerHTML={{"__html": html}} />
  </Layout_Main>
}
