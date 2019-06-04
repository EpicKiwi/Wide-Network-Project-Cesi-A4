#!/bin/env bash

currentInterface=""
currentDescription=""
currentIp=""
currentMask=""
currentEncapsulation=""
currentVrf=""
currentRouting=""

function generatedoc {
	echo "		\item[$currentInterface] $currentDescription"
	echo "		\begin{description}"

	if [ "$currentIp" != "" ]; then
		echo "			\item[IP] \texttt{$currentIp} (\texttt{$currentMask})"
	fi

	if [ "$currentEncapsulation" != "" ]; then
		echo "			\item[Encapsulation serie] $currentEncapsulation"
	fi

	if [ "$currentVrf" != "" ]; then
		echo "			\item[VRF Dédiée] $currentVrf"
	fi

	echo "		\end{description}"
	echo ""
}

function generaterouting {
	echo "		\item[Routage] $currentRouting"
}

for file in $@; do

	NAME=$(basename $file .cfg)

	echo "\subsection{$NAME}"
	echo ""
	echo "	\begin{description}"

	cat "$file" | sed -n '/\(interface\|router\)/,/^\s*$/Ip' | while read line; do
		
		if ( echo "$line" | grep "^router" -I >> /dev/null ) ; then
			newRouting=$(echo "$line" | sed "s/^router \(.*\)$/\1/I")
			echo "		\item[Routage] $newRouting"
		elif ( echo "$line" | grep "^interface" -I >> /dev/null ) ; then
			newInterface=$(echo "$line" | sed "s/^interface \(.*\)$/\1/I")
			if [ "$currentInterface" != "" ]; then
				generatedoc
			fi
			currentInterface="$newInterface"
			currentDescription=""
			currentIp=""
			currentMask=""
			currentEncapsulation=""
			currentVrf=""
		elif ( echo "$line" | grep -E "^\s*description" -I >> /dev/null ) ; then
			currentDescription=$(echo "$line" | sed "s/^\s*description \(.*\)$/\1/I")
		elif ( echo "$line" | grep -E "^\s*ip address" -I >> /dev/null ) ; then
			ipLine=$(echo "$line" | sed "s/^\s*ip address //I")
			currentIp=$(echo "$ipLine" | cut -f1 -d' ')
			currentMask=$(echo "$ipLine" | cut -f2 -d' ')
		elif ( echo "$line" | grep -E "^\s*encapsulation" -I >> /dev/null ) ; then
			currentEncapsulation=$(echo "$line" | sed "s/^\s*encapsulation \(.*\)$/\1/I")
		elif ( echo "$line" | grep -E "^\s*ip vrf forwarding" -I >> /dev/null ) ; then
			currentVrf=$(echo "$line" | sed "s/^\s*ip vrf forwarding \(.*\)$/\1/I")
		fi

	done;
	echo "	\end{description}"
	#echo "	\lstinputlisting[caption=Configuration de la machine $NAME]{$file}"
	#echo "	\clearpage"

done
