type opaque
external opaque: 'a => opaque = "%identity"

let or = (a: {..}, b: {..}) => {"$or": [opaque(a), opaque(b)]}
let merge = (a: {..}, b: {..}) => Js.Obj.assign(a, b)
let merge3 = (a: {..}, b: {..}, c: {..}) => merge(a, b)->Js.Obj.assign(c)
let merge4 = (a: {..}, b: {..}, c: {..}, d: {..}) => merge3(a, b, c)->Js.Obj.assign(d)
