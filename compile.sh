#!/bin/bash

# Compile the 181 paper
cd report && cp proposal.tex m181-paper.tex && bmbcompile m181-paper && cd ..
