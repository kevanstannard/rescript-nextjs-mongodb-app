// Generated by ReScript, PLEASE EDIT WITH CARE


function makeResult(param) {
  return {
          props: {
            msg: "This page was rendered with getServerSideProps. You can find the source code here: ",
            href: "https://github.com/ryyppy/nextjs-default/tree/master/src/Examples.res"
          },
          redirect: undefined,
          notFound: undefined
        };
}

function getServerSideProps(_context) {
  return Promise.resolve({
              props: {
                msg: "This page was rendered with getServerSideProps. You can find the source code here: ",
                href: "https://github.com/ryyppy/nextjs-default/tree/master/src/Examples.res"
              },
              redirect: undefined,
              notFound: undefined
            });
}

export {
  makeResult ,
  getServerSideProps ,
  
}
/* No side effect */
