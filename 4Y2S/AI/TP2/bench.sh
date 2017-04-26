#!/bin/bash

if [ -z $1 ]; then
    echo "usage: $0 MAX_DEPTH"
    exit 1
fi

TIME=/usr/bin/time
ECLIPSE=/usr/local/eclipse.prolog/bin/x86_64_linux/eclipse
NRUNS=10

rm tmp.run
for i in `seq 1 $NRUNS`; do
    $TIME --format "%e" -o tmp.run --append $ECLIPSE -f negamax.pl -e "main(C,V,$1)."
done
echo -n "0.0" >> tmp.run

python -c "print(("$(cat tmp.run | tr "\n" "+")")/"$NRUNS")"
