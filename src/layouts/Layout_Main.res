open Layout_Common

@react.component
let make = (~user: option<Common_User.User.t>, ~children: React.element) => {
  <>
    <Header user={user} />
    <ContentContainer> <div className="mb-48"> {children} </div> </ContentContainer>
    <Footer />
  </>
}
