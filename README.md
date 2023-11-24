## Farmer: The Yield Optimiser

**Farmer will invest your assets into multiple lending and liquidity pools to earn yields and return compounded value.**

Farmer Finance consists of:

-   **Vault**: Vault contract will collect the assets the user wants to invest and pass it onto the strategy contract for investing.
  
-   **Strategy**: Strategy contracts will enable dynamic funds distribution. Tokens will be deposited as collateral to generate yield from lending protocols.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Deploy
```shell
$ forge script script/DeployVault.s.sol:DeployVault --rpc-url $(Georli_RPC_URL) --private-key $(Georli_PRIVATE_KEY)
-- broadcast```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
