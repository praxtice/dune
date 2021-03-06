open Stdune
open Action

include module type of struct include Action_dune_lang end

module Partial : sig
  include Action_intf.Ast
    with type program = (Unresolved.Program.t, String_with_vars.t) either
    with type path    = (Path.t              , String_with_vars.t) either
    with type string  = (String.t            , String_with_vars.t) either

  val expand
    :  t
    -> map_exe:(Path.t -> Path.t)
    -> expander:Expander.t
    -> Unresolved.t
end

val partial_expand
  :  t
  -> map_exe:(Path.t -> Path.t)
  -> expander:Expander.t
  -> Partial.t

val remove_locs : t -> t

(** Infer dependencies and targets.

    This currently doesn't support well (rename ...) and (remove-tree ...). However these
    are not exposed in the DSL.
*)
module Infer : sig
  module Outcome : sig
    type t =
      { deps    : Path.Set.t
      ; targets : Path.Set.t
      }
  end

  val infer : Action.t -> Outcome.t

  (** If [all_targets] is [true] and a target cannot be determined statically, fail *)
  val partial : all_targets:bool -> Partial.t -> Outcome.t

  (** Return the list of targets of an unexpanded action. *)
  val unexpanded_targets : t -> String_with_vars.t list
end

