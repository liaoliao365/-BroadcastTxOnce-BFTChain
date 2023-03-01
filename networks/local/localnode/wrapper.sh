#!/usr/bin/env sh

##
## Input parameters
##

# docker run -v /home/lele/go/src/github.com/tendermint/build_my:/tendermint_my_build
BINARY=tendermint_my
# echo ${BINARY}

BINARY=/tendermint/${BINARY:-tendermint}
echo ${BINARY}
ID=${ID:-0}
LOG=${LOG:-tendermint.log}

##
## Assert linux binary
##
echo ${BINARY}
if ! [ -f "${BINARY}" ]; then
    echo "${BINARY}"
    echo "The binary $(basename "${BINARY}") cannot be found. Please add the binary to the shared folder. Please use the BINARY environment variable if the name of the binary is not 'tendermint' E.g.: -e BINARY=tendermint_my_test_version"
    exit 1
fi
BINARY_CHECK="$(file "$BINARY" | grep 'ELF 64-bit LSB executable, x86-64')"
if [ -z "${BINARY_CHECK}" ]; then
    echo "Binary needs to be OS linux, ARCH amd64"
    exit 1
fi

##
## Run binary with all parameters
##
export TMHOME="/tendermint/node${ID}"

if [ -d "`dirname ${TMHOME}/${LOG}`" ]; then
    "$BINARY" "$@" | tee "${TMHOME}/${LOG}"
else
    "$BINARY" "$@"
fi

chmod 777 -R /tendermint

