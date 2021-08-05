@react.component
let make = (~href: string, ~children: React.element) => {
  let className = "font-medium hover:underline text-green-600"
  <Next.Link href={href}> <a className={className}> {children} </a> </Next.Link>
}
