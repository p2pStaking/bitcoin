To build a bitcoin-core version from its github repo: 

```BITCOIN_CORE_VERSION=26.1```

and 

```
docker build . -t p2pstaking/bitcoin-core:$BITCOIN_CORE_VERSION
docker push p2pstaking/bitcoin-core:$BITCOIN_CORE_VERSION
```

if latest

```
docker tag p2pstaking/bitcoin-core:$BITCOIN_CORE_VERSION p2pstaking/bitcoin-core:latest
docker push p2pstaking/bitcoin-core:latest
```


