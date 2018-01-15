(**************************************************************************)
(*                                                                        *)
(*    Copyright (c) 2014 - 2016.                                          *)
(*    Dynamic Ledger Solutions, Inc. <contact@tezos.com>                  *)
(*                                                                        *)
(*    All rights reserved. No warranty, explicit or implicit, provided.   *)
(*                                                                        *)
(**************************************************************************)

module Sodium = Helpers_sodium
module Cast = Helpers_cast
module Assert = Helpers_assert
module Services = Helpers_services
module Constants = Helpers_constants
module Account = Helpers_account
module Misc = Helpers_misc
module Operation = Helpers_operation
module Block = Helpers_block
module Init = Helpers_init
module Apply = Helpers_apply
module Script = Helpers_script

module Shorthands = struct

  let to_tc ctxt = Misc.get_dummy_tezos_context ctxt

  let to_tc_full ctxt level fitness =
    Tezos_context.init
      ctxt
      ~level
      ~fitness
      ~timestamp:(Time.now())

  let get_tc (res:Block.result) =
    to_tc res.validation.context

  let get_tc_full (res:Block.result) =
    Tezos_context.init
      res.validation.context
      ~level:res.level
      ~timestamp:res.tezos_header.shell.timestamp
      ~fitness:res.validation.fitness

  let get_balance_res (account:Account.t) (result:Block.result) =
    let open Proto_alpha.Error_monad in
    get_tc_full result >>=? fun tc ->
    Proto_alpha.Tezos_context.Contract.get_balance tc account.contract

  let chain_empty_block (result:Block.result) =
    Block.empty
      result.tezos_header.shell
      result.hash
      result.level
      15
      result.validation.context

end