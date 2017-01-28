(**
 * Copyright (c) 2016, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

module Types = struct

  exception Timeout

  type init_settings = {
    subscribe_to_changes: bool;
    (** Seconds used for init timeout - will be reused for reinitialization. *)
    init_timeout: int;
    sync_directory: string;
    root: Path.t;
  }

  type pushed_changes =
    (** State name and metadata. *)
    | State_enter of string * Hh_json.json option
    | State_leave of string * Hh_json.json option
    | Files_changed of SSet.t

  type changes =
    | Watchman_unavailable
    | Watchman_pushed of pushed_changes
    | Watchman_synchronous of SSet.t
end

(** The abstract types, and the types that are defined in terms of
 * abstract types must be split out. The reason is left as an exercise
 * to the reader (i.e. try it yourself out a few ways and you'll discover the
 * limitations - whether your strategy is splitting up the definitions
 * into 3 modules "base types, abstract types, dependent types", or
 * if you change this to a functor). *)
module Abstract_types = struct
  type env
  type dead_env
  (** This has to be repeated because they depend on the abstract types. *)
  type watchman_instance =
    | Watchman_dead of dead_env
    | Watchman_alive of env
end

module type S = sig

  include module type of Types
  include module type of Abstract_types

  val crash_marker_path: Path.t -> string

  val init: init_settings -> env option

  val get_all_files: env -> string list

  val get_changes: ?deadline:float ->
    watchman_instance -> watchman_instance * changes
  val get_changes_synchronously: timeout:int ->
    watchman_instance -> watchman_instance * SSet.t

  (** Exposing things for unit tests.
   *
   * We have to double-declare the module signature in this .mli and in the .ml
   * which is unfortunate, but because we use the abstract type "env", the
   * alternative would involve verbose mutuaully-recursive modules.*)
  module type Testing_sig = sig
    val test_env : env
    val transform_asynchronous_get_changes_response :
      env -> Hh_json.json -> env * pushed_changes
  end

  module Testing : Testing_sig

end
