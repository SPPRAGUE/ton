contract AbiTests {
    author: "Tolk team"
    version: "1.0"
    description: "ABI export regression test"
    storage: ContractStorage
    storageAtDeployment: InitStorage
    incomingMessages: Increment | Reset
    forceAbiExport: ExtraPayload
}

/// just a comment, not description because of semicolon
;
/// Persistent contract data
struct ContractStorage {
    /// Current counter value
    counter: int32
    /// Contract owner
    owner: address
}

/// Initial deployment data.
struct InitStorage {
    /// Contract owner at deployment
    owner: address
}

/// Extra payload exported on demand.
struct ExtraPayload {
    /// Human-readable note
    @abi.clientType(string)
    note: RemainingBitsAndRefs
}

/// Increases the counter.
struct (0x01) Increment {
    /// Amount to add
    by: int32
    queryId: uint64 = 0
}

/// Resets the counter.
struct (0x02) Reset {
    /// New counter value
    value: int32
}

/// Swap on DEX.
struct (0x13) SwapMM {
}

const ERR_UNUSED_ABI = 777

struct (0x14) UnusedOutgoing {
}

fun unusedAbiRoot() {
    unusedAbiThrow();
    unusedAbiOutgoing();
}

fun unusedAbiThrow() {
    throw ERR_UNUSED_ABI;
}

fun unusedAbiOutgoing() {
    createMessage({
        bounce: BounceMode.NoBounce,
        value: ton("0.1"),
        dest: address("0:ca6e321c7cce9ecedf0a8ca2492ec8592494aa5fb5ce0387dff96ef6af982a3e"),
        body: UnusedOutgoing {}.toCell(),
    });
}

/// Runs a tiny script.
/// Not onInternalMessage.
/// @param amount initial stack value
/// @param times added stack value
fun main(amount: int, times: int): int {
    createMessage({
        bounce: BounceMode.NoBounce,
        value: ton("0.1"),
        dest: address("0:ca6e321c7cce9ecedf0a8ca2492ec8592494aa5fb5ce0387dff96ef6af982a3e"),
        body: SwapMM {}.toCell(),
    });
    return amount + times;
}

/// Reads current counter.
/// From storage.
get fun currentCounter(): int32 {
    val storage = lazy ContractStorage.fromCell(contract.getData());
    return storage.counter;
}

/**
@testcase | 0 | 7 5 | 12

@abi_json
"""
  "contract_name": "AbiTests",
  "author": "Tolk team",
  "version": "1.0",
  "description": "ABI export regression test",
"""

@abi_json
"""
    {
      "kind": "struct",
      "name": "Increment",
      "prefix": {
        "prefix_num": 1,
        "prefix_len": 8
      },
      "fields": [
        {
          "name": "by",
          "ty_idx": {"kind":"intN","n":32},
          "description": "Amount to add"
        },
        {
          "name": "queryId",
          "ty_idx": {"kind":"uintN","n":64},
          "default_value": {
            "kind": "int",
            "v": "0"
          }
        }
      ],
      "description": "Increases the counter."
    },
"""

@abi_json
"""
    {
      "kind": "struct",
      "name": "ContractStorage",
      "fields": [
        {
          "name": "counter",
          "ty_idx": {"kind":"intN","n":32},
          "description": "Current counter value"
        },
        {
          "name": "owner",
          "ty_idx": {"kind":"address"},
          "description": "Contract owner"
        }
      ],
      "description": "Persistent contract data"
    },
"""

@abi_json
"""
    {
      "kind": "struct",
      "name": "ExtraPayload",
      "fields": [
        {
          "name": "note",
          "ty_idx": {"kind":"remaining"},
          "client_ty": {"kind":"string"},
          "description": "Human-readable note"
        }
      ],
      "description": "Extra payload exported on demand."
    },
"""

@abi_json
"""
  "storage": {
    "storage_ty": {"kind":"StructRef","struct_name":"ContractStorage"},
    "storage_at_deployment_ty": {"kind":"StructRef","struct_name":"InitStorage"}
  },
"""

@abi_json
"""
  "incoming_messages": [
    {
      "body_ty": {"kind":"StructRef","struct_name":"Increment"}
    },
    {
      "body_ty": {"kind":"StructRef","struct_name":"Reset"}
    }
  ],
"""

@abi_json
"""
  "get_methods": [
    {
      "tvm_method_id": 0,
      "name": "main",
      "parameters": [
        {
          "name": "amount",
          "ty": {"kind":"int"},
          "description": "initial stack value"
        },
        {
          "name": "times",
          "ty": {"kind":"int"},
          "description": "added stack value"
        }
      ],
      "return_ty": {"kind":"int"},
      "description": "Runs a tiny script.\nNot onInternalMessage."
    },
    {
      "tvm_method_id": 117456,
      "name": "currentCounter",
      "parameters": [
      ],
      "return_ty": {"kind":"intN","n":32},
      "description": "Reads current counter.\nFrom storage."
    }
  ],
"""

@abi_json
"""
  "outgoing_messages": [
    {
      "body_ty": {"kind":"StructRef","struct_name":"SwapMM"}
    }
  ],
"""

@abi_json_avoid UnusedOutgoing
@abi_json_avoid ERR_UNUSED_ABI
 */
