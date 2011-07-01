#!/bin/bash
EXPECTED_ARGS=1
if [ $# -ne $EXPECTED_ARGS ]
then
	echo "Usage: `basename $0` [noop|reallyrun]"
        exit
fi

NOOP="--noop"
if [ "$1" = "reallyrun" ]
then
	NOOP=""
fi

PWD=`pwd`
MODULEPATH="$PWD/..:$PWD/../../site:$PWD/../../base"

LIBDIR=""

if [ -d $PWD/lib ]
then
	LIBDIR="--libdir $PWD/lib"
fi

echo "MODULEPATH: $MODULEPATH LIBDIR: $LIBDIR"

puppet $NOOP $DEBUG --modulepath=$MODULEPATH $LIBDIR test/init.pp
exit 0
