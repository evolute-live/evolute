# evolute blockchain

the evolving blockchain :rocket:

## getting started

depending on your operating system and rust version, there might be additional
packages required to compile this project. check the
[install](https://docs.substrate.io/install/) instructions for your platform for
the most common dependencies. alternatively, you can use one of the [alternative
installation](#alternatives-installations) options.

fetch evolute code:

```sh
git clone https://github.com/evolute-live/evolute.git evolute

cd evolute
```

### build

🔨 use the following command to build the node without launching it:

```sh
cargo build --release
```

### embedded docs

after you build the project, you can use the following command to explore its
parameters and subcommands:

```sh
./target/release/evolute-node -h
```

you can generate and view the [rust
docs](https://doc.rust-lang.org/cargo/commands/cargo-doc.html) for this template
with this command:

```sh
cargo +nightly doc --open
```

### single-node development chain

the following command starts a single-node development chain that doesn't
persist state:

```sh
./target/release/evolute-node --dev
```

to purge the development chain's state, run the following command:

```sh
./target/release/evolute-node purge-chain --dev
```

to start the development chain with detailed logging, run the following command:

```sh
RUST_BACKTRACE=1 ./target/release/evolute-node -ldebug --dev
```

development chains:

- maintain state in a `tmp` folder while the node is running.
- use the **alice** and **bob** accounts as default validator authorities.
- use the **alice** account as the default `sudo` account.
- are preconfigured with a genesis state (`/node/src/chain_spec.rs`) that
  includes several pre-funded development accounts.


to persist chain state between runs, specify a base path by running a command
similar to the following:

```sh
// create a folder to use as the db base path
$ mkdir my-chain-state

// use of that folder to store the chain state
$ ./target/release/evolute-node --dev --base-path ./my-chain-state/

// check the folder structure created inside the base path after running the chain
$ ls ./my-chain-state
chains
$ ls ./my-chain-state/chains/
dev
$ ls ./my-chain-state/chains/dev
db keystore network
```

### connect with polkadot-js apps front-end

after you start the node template locally, you can interact with it using the
hosted version of the [polkadot/substrate
portal](https://polkadot.js.org/apps/#/explorer?rpc=ws://localhost:9944)
front-end by connecting to the local node endpoint. a hosted version is also
available on [ipfs](https://dotapps.io/). you can
also find the source code and instructions for hosting your own instance in the
[`polkadot-js/apps`](https://github.com/polkadot-js/apps) repository.

### multi-node local testnet

if you want to see the multi-node consensus algorithm in action, see [simulate a
network](https://docs.substrate.io/tutorials/build-a-blockchain/simulate-network/).

## template structure

a substrate project such as this consists of a number of components that are
spread across a few directories.

### node

a blockchain node is an application that allows users to participate in a
blockchain network. substrate-based blockchain nodes expose a number of
capabilities:

- networking: substrate nodes use the [`libp2p`](https://libp2p.io/) networking
  stack to allow the nodes in the network to communicate with one another.
- consensus: blockchains must have a way to come to
  [consensus](https://docs.substrate.io/fundamentals/consensus/) on the state of
  the network. substrate makes it possible to supply custom consensus engines
  and also ships with several consensus mechanisms that have been built on top
  of [web3 foundation
  research](https://research.web3.foundation/Polkadot/protocols/NPoS).
- rpc server: a remote procedure call (rpc) server is used to interact with
  substrate nodes.

there are several files in the `node` directory. take special note of the
following:

- [`chain_spec.rs`](./node/src/chain_spec.rs): a [chain
  specification](https://docs.substrate.io/build/chain-spec/) is a source code
  file that defines a substrate chain's initial (genesis) state. chain
  specifications are useful for development and testing, and critical when
  architecting the launch of a production chain. take note of the
  `development_config` and `testnet_genesis` functions. these functions are
  used to define the genesis state for the local development chain
  configuration. these functions identify some [well-known
  accounts](https://docs.substrate.io/reference/command-line-tools/subkey/) and
  use them to configure the blockchain's initial state.
- [`service.rs`](./node/src/service.rs): this file defines the node
  implementation. take note of the libraries that this file imports and the
  names of the functions it invokes. in particular, there are references to
  consensus-related topics, such as the [block finalization and
  forks](https://docs.substrate.io/fundamentals/consensus/#finalization-and-forks)
  and other [consensus
  mechanisms](https://docs.substrate.io/fundamentals/consensus/#default-consensus-models)
  such as aura for block authoring and grandpa for finality.


### runtime

in substrate, the terms "runtime" and "state transition function" are analogous.
both terms refer to the core logic of the blockchain that is responsible for
validating blocks and executing the state changes they define. the substrate
project in this repository uses
[frame](https://docs.substrate.io/learn/runtime-development/#frame) to construct
a blockchain runtime. frame allows runtime developers to declare domain-specific
logic in modules called "pallets". at the heart of frame is a helpful [macro
language](https://docs.substrate.io/reference/frame-macros/) that makes it easy
to create pallets and flexibly compose them to create blockchains that can
address [a variety of needs](https://substrate.io/ecosystem/projects/).

review the [frame runtime implementation](./runtime/src/lib.rs) included in this
template and note the following:

- this file configures several pallets to include in the runtime. each pallet
  configuration is defined by a code block that begins with `impl
  $PALLET_NAME::Config for Runtime`.
- the pallets are composed into a single runtime by way of the
  [#[runtime]](https://paritytech.github.io/polkadot-sdk/master/frame_support/attr.runtime.html)
  macro, which is part of the [core frame pallet
  library](https://docs.substrate.io/reference/frame-pallets/#system-pallets).

### pallets

the runtime in this project is constructed using many frame pallets that ship
with [the substrate
repository](https://github.com/paritytech/polkadot-sdk/tree/master/substrate/frame) and a
template pallet that is [defined in the
`pallets`](./pallets/template/src/lib.rs) directory.

a frame pallet is comprised of a number of blockchain primitives, including:

- storage: frame defines a rich set of powerful [storage
  abstractions](https://docs.substrate.io/build/runtime-storage/) that makes it
  easy to use substrate's efficient key-value database to manage the evolving
  state of a blockchain.
- dispatchables: frame pallets define special types of functions that can be
  invoked (dispatched) from outside of the runtime in order to update its state.
- events: substrate uses
  [events](https://docs.substrate.io/build/events-and-errors/) to notify users
  of significant state changes.
- errors: when a dispatchable fails, it returns an error.

each pallet has its own `Config` trait which serves as a configuration interface
to generically define the types and parameters it depends on.

## alternatives installations

instead of installing dependencies and building this source directly, consider
the following alternatives.

### nix

install [nix](https://nixos.org/) and
[nix-direnv](https://github.com/nix-community/nix-direnv) for a fully
plug-and-play experience for setting up the development environment. to get all
the correct dependencies, activate direnv `direnv allow`.

### docker

please follow the [substrate docker instructions
here](https://github.com/paritytech/polkadot-sdk/blob/master/substrate/docker/README.md) to
build the docker container with the evolute binary.
