## Building

### local build
 
```sh
docker build -t docker/lsp:treesitter-local
```

### release build (on cloud)

```sh
docker buildx build --builder hydrobuild --platform linux/amd64,linux/arm64 --tag docker/lsp:treesitter --push .
```
