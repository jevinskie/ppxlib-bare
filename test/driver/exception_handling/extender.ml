open Ppxlib

let expand_into_extension_node ~ctxt =
  let loc = Expansion_context.Extension.extension_point_loc ctxt in
  let extension_node =
    Location.error_extensionf ~loc "An error message in an extension node"
  in
  Ast_builder.Default.pexp_extension ~loc extension_node

let expand_raise_exception ~ctxt:_ = failwith "A raised exception"

let expand_raise_located_error ~ctxt =
  let loc = Expansion_context.Extension.extension_point_loc ctxt in
  Location.raise_errorf ~loc "A raised located error"

let expand_raise_located_error2 ~ctxt =
  let loc = Expansion_context.Extension.extension_point_loc ctxt in
  Location.raise_errorf ~loc "A second raised located error"

let extension_point_extension =
  Extension.V3.declare "gen_ext_node" Extension.Context.expression
    Ast_pattern.(pstr nil)
    expand_into_extension_node

let raise_exception_extension =
  Extension.V3.declare "gen_raise_exc" Extension.Context.expression
    Ast_pattern.(pstr nil)
    expand_raise_exception

let raise_located_error_extension =
  Extension.V3.declare "gen_raise_located_error" Extension.Context.expression
    Ast_pattern.(pstr nil)
    expand_raise_located_error

let raise_located_error_extension2 =
  Extension.V3.declare "gen_raise_located_error2" Extension.Context.expression
    Ast_pattern.(pstr nil)
    expand_raise_located_error2

let rule1 = Ppxlib.Context_free.Rule.extension extension_point_extension
let rule2 = Ppxlib.Context_free.Rule.extension raise_exception_extension
let rule3 = Ppxlib.Context_free.Rule.extension raise_located_error_extension
let rule4 = Ppxlib.Context_free.Rule.extension raise_located_error_extension2

let () =
  Driver.register_transformation
    ~rules:[ rule1; rule2; rule3; rule4 ]
    "gen_errors"

let () = Driver.standalone ()
