#!/bin/bash

if [[ "$#" -ne 4 ]]; then
    echo "Usage: $0 program_binary output_trace_name instrs_to_be_skipped instrs_to_be_instrumented"
    exit 1
fi

PIN_BINARY=../pin-3.2-81205-gcc-linux/pin

PROGRAM_BINARY=${1?Program to be instrumented missed!}
OUTPUT_NAME=${2?Output name missed!}
SKIP_INSTRS=${3?Skip instructions misses!}
INSTRUMENT_INSTRS=${4?Number of instructions to be instrumented missed!}

if ! [[ -f $PIN_BINARY ]]; then
    echo "Couldn't find pin binary!"
    exit 1
fi

./$PIN_BINARY -injection child -ifeellucky -t obj-intel64/champsim_tracer.so -o $OUTPUT_NAME -s $SKIP_INSTRS -t $INSTRUMENT_INSTRS -- $PROGRAM_BINARY
