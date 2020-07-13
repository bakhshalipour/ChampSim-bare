#!/bin/bash

TRACE_DIR=/proj/PrescriptiveMem/benchmarks/champsim-traces

if [ "$#" -lt 5 ]; then
    echo "Illegal number of parameters"
    echo "TRACE_DIR: $TRACE_DIR"
    echo "Usage: ./run_champsim.sh [BINARY] [N_WARM]M [N_SIM]M [TRACE] [EXPERIMENT_NAME] [OPTION]"
    exit 1
fi

BINARY=${1}
BINARY=${BINARY#bin/}   # Remove 'bin/' from the beginning if exists

N_WARM=${2}
N_SIM=${3}

# $TRACE should be the absolute path of the final trace file
TRACE=${4}
TRACE_NAME=${TRACE##*/}
TRACE_NAME=${TRACE_NAME%.champsimtrace.xz}

EXPERIMENT_NAME=${5}
OPTION=${6}

# Sanity check
if [ ! -f "bin/$BINARY" ] ; then
    echo "[ERROR] Cannot find a ChampSim binary: bin/$BINARY"
    exit 1
fi

re='^[0-9]+$'
if ! [[ $N_WARM =~ $re ]] || [ -z $N_WARM ] ; then
    echo "[ERROR]: Number of warmup instructions is NOT a number" >&2;
    exit 1
fi

re='^[0-9]+$'
if ! [[ $N_SIM =~ $re ]] || [ -z $N_SIM ] ; then
    echo "[ERROR]: Number of simulation instructions is NOT a number" >&2;
    exit 1
fi

if [ ! -f "$TRACE" ] ; then
    echo "[ERROR] Cannot find a trace file: $TRACE"
    exit 1
fi

RES_DIR="results/results_${EXPERIMENT_NAME}"
RES_FILE_NAME="${TRACE_NAME}-${BINARY}${OPTION}.txt"

if [[ -f ${RES_DIR}/${RES_FILE_NAME} ]]; then
    read -p "Overwriting? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
fi

mkdir -p $RES_DIR
(./bin/${BINARY} -warmup_instructions ${N_WARM}000000 -simulation_instructions ${N_SIM}000000 ${OPTION} -traces ${TRACE}) &> ${RES_DIR}/${TRACE_NAME}-${BINARY}${OPTION}.txt

