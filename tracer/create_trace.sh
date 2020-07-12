#!/bin/bash

if [[ "$#" -ne 4 ]]; then
    echo "Usage: $0 program_binary output_trace_name instrs_to_be_skipped instrs_to_be_instrumented"
    exit 1
fi

if ! [[ -f pin ]]; then
    if ! [[ -f ../pin-3.2-81205-gcc-linux/pin ]]; then
        echo "Couldn't find PIN binary!"
        exit 1
    fi

    ln -s ../pin-3.2-81205-gcc-linux/pin pin
fi

PROGRAM_BINARY=$1
PROGRAM_BINARY=$(readlink -f $PROGRAM_BINARY)
OUTPUT_NAME=$2
SKIP_INSTRS=$3
INSTRUMENT_INSTRS=$4

./pin -injection child -ifeellucky -t obj-intel64/champsim_tracer.so -o $OUTPUT_NAME -s $SKIP_INSTRS -t $INSTRUMENT_INSTRS -- $PROGRAM_BINARY

