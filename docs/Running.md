# Running

## From command line
```sh
./pharo Pharo.image start --api-server-url=http://example.com --port=8080
```

- `--api-server-url=<url>` is the public url to use on API references.
- Optional `--port=<port>` is the port to use for the API, defaults to 8080 if absent.
- Optional `--debug-mode` if you want to debug and not close the application on errors.
- Optional `--suspend-ui` if running on headless, to improve performance.

## In a playground
```smalltalk
OKRCommandLineHandler new startServedOn: anUrl listeningOn: aPort
```
