#!/bin/env bash

./generate-topology.sh ../network/nuage-supra/* > topology-spr.tex
./generate-topology.sh ../network/direction-general/* | sed "s/subsection/subsubsection/" > topology-DG.tex
./generate-topology.sh ../network/agence-commerciale/* | sed "s/subsection/subsubsection/" > topology-AC.tex
./generate-topology.sh ../network/unite-production/* | sed "s/subsection/subsubsection/" > topology-UP.tex
./generate-topology.sh ../network/unite-stockage/* | sed "s/subsection/subsubsection/" > topology-US.tex
./generate-topology.sh ../network/ACC-IN.cfg | sed "s/subsection/subsubsection/" > topology-ACC-IN.tex
./generate-topology.sh ../network/BP-Front.cfg | sed "s/subsection/subsubsection/" > topology-BP.tex