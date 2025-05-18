name: Build Linux 386 Binaries for CentOS 5.11

on:
  workflow_dispatch:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  build-linux-386:
    name: Build Linux 386 (i686, glibc 2.5+) Binaries
    runs-on: ubuntu-latest
    timeout-minutes: 30
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Go
        uses: actions/setup-go@v5
        with:
          go-version: "1.21"

      - name: Build Linux 386 binaries (client & server)
        run: |
          make clean
          GOOS=linux GOARCH=386 CGO_ENABLED=0 make clients
          GOOS=linux GOARCH=386 CGO_ENABLED=0 make servers
          mkdir -p ./linux386_build
          cp ./sliver-client_linux-386* ./linux386_build/ 2>/dev/null || true
          cp ./sliver-server_linux-386* ./linux386_build/ 2>/dev/null || true

      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: linux386-binaries
          path: ./linux386_build/
