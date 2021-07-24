let set = (name: string, value: 'a) => {
  NodeGlobal.instance->NodeGlobal.set(name, value)
}

let get = (name: string): option<'a> => {
  NodeGlobal.instance->NodeGlobal.get(name)
}
