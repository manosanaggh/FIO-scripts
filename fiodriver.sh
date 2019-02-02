#!/usr/bin/env bash

DEVICES=( sdb )
THREADS=8
IODEPTH=( 1 4 16 32 64 )
FIO_SCRIPTS='FIO-scripts'

OUTPUT=$(date "+%F_%R")
OUTPUT="FIO-${OUTPUT}"

mkdir "$OUTPUT"

for DEVICE in ${DEVICES}; do
	# RANDOM WRITES
	for IOD in ${IODEPTH[@]}; do
		./runfio.sh -d "$DEVICE" -n "$THREADS" -i "$IOD" -f "${FIO_SCRIPTS}/rand-write.fio" -o "${OUTPUT}/rand_w_${DEVICE}_${IOD}iodepth_${THREADS}threads"
	done

	# SEQUENTIAL WRITES
	for IOD in ${IODEPTH[@]}; do
		./runfio.sh -d "$DEVICE" -n 1 -i "$IOD" -f "${FIO_SCRIPTS}/write.fio" -o "${OUTPUT}/seq_w_${DEVICE}_${IOD}iodepth"
	done

	# RANDOM READS
	for IOD in ${IODEPTH[@]}; do
		./runfio.sh -d "$DEVICE" -n "$THREADS" -i "$IOD" -f "${FIO_SCRIPTS}/rand-read.fio" -o "${OUTPUT}/rand_r_${DEVICE}_${IOD}iodepth_${THREADS}threads"
	done

	# SEQUENTIAL READS
	for IOD in ${IODEPTH[@]}; do
		./runfio.sh -d "$DEVICE" -n 1 -i "$IOD" -f "${FIO_SCRIPTS}/read.fio" -o "${OUTPUT}/seq_r_${DEVICE}_${IOD}iodepth"
	done
done
