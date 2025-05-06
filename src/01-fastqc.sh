#!/usr/bin/env bash


cd .. #assumed running in src
mkdir -p results/fastqc
fastqc data/*.fq* -o results/fastqc
