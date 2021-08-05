module Title = Component_Title
module Link = Component_Link

@react.component
let make = (~user) => {
  <Layout_Main user={user}>
    <Title text="Hello" size=#Primary />
    <p className="mb-4">
      {React.string(
        "This is an example application to demonstrate using ReScript, NextJS and MongoDB together.",
      )}
    </p>
  </Layout_Main>
}
