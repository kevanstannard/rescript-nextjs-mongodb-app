module Title = Component_Title
module Link = Component_Link

@react.component
let make = (~user) => {
  <Layout_Main user={user}>
    <Title text="Hello" size=#Primary />
    <p className="mb-4">
      {React.string(
        "This is an example application to demonstrate using ReScript MongoDB and NextJS together.",
      )}
    </p>
    <p className="mb-4">
      <Link href={Common_Url.github()}> {"View the source code on Github"->React.string} </Link>
    </p>
  </Layout_Main>
}
