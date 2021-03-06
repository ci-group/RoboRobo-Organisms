#!/bin/bash

### Set the simulation-specific parameters
DIR=$(cd "$(dirname "$0")"; pwd -P)
BASEDIR="$(dirname $DIR)/"
TEMPLATEDIR=scripts/templates/
CONFNAME=symbrion_7_p
TESTNAME=symbrion_7_p

FULLCOMMAND="$0 $@"
. ${BASEDIR}/scripts/shflags

#define the flags
DEFINE_integer 'repeats' '30' 'The number of times the simulation should be run';
DEFINE_string 'robots' '10' 'The number of robots in the simulation' 'n';
DEFINE_integer 'seed' '-1' 'Seed' 'x';
DEFINE_string 'mu' '5' 'Mu' 'm'
DEFINE_string 'stepsPerCandidate' '500' 'Steps per candidate' 't'
DEFINE_string 'reEvaluationRate' '0.1' 'Re-evaluation Rate' 'r'
DEFINE_string 'crossoverRate' '1.0' 'Crossover rate' 'c'
DEFINE_string 'mutationRate' '1.0' 'Mutation rate' 'p'
DEFINE_string 'initialMutationStepSize' '5' 'Initial mutation step size' 's'
DEFINE_string 'newscastCacheSize' '4' 'Newscast cache size' 'C'
DEFINE_string 'newscastItemTTL' '8' 'Number of generations a Newscast item can live' 'L'
DEFINE_string 'numberOfParents' '2' 'Number of parents' 'P'
DEFINE_string 'iterations' '500000' 'Number of iterations' 'i'
DEFINE_string 'startHormones' '2' 'Number of start hormones' 'H'
DEFINE_string 'startRules' '20' 'Number of start rules' 'R'
#DEFINE_string 'connectionType' '0' 'Connection Type'

RANDOM=42

MU=3
ROBOTS=60
MUTATIONRATE=0.573691070079803
CROSSOVERRATE=0.036018982529640
REEVALUATIONRATE=0.623848140239715
STEPSPERCANDIDATE=800
INITIALMUTATIONSTEPSIZE=0.01
ITERATIONS=500000
#CONNECTIONTYPE=7

# Parse the flags
FLAGS "$@" || exit 1
eval set -- "${FlAGS_ARGV}"

### Run the simulation
COUNTER=${FLAGS_repeats}

echo "starting simulations, repeating $COUNTER times"
cd $BASEDIR

run_roborobo() {
    echo "Running experiment #$EXPERIMENT with parameters: --mu $MU --stepsPerCandidate $STEPSPERCANDIDATE --mutationRate $MUTATIONRATE --crossoverRate $CROSSOVERRATE --reEvaluationRate $REEVALUATIONRATE --initialMutationStepSize $INITIALMUTATIONSTEPSIZE --iterations $ITERATIONS --seed $SEED"
    . ${BASEDIR}scripts/run_scale.sh --mu $MU --stepsPerCandidate $STEPSPERCANDIDATE --mutationRate $MUTATIONRATE --crossoverRate $CROSSOVERRATE --reEvaluationRate $REEVALUATIONRATE --initialMutationStepSize $INITIALMUTATIONSTEPSIZE --iterations $ITERATIONS --seed $SEED > /dev/null 2> /dev/null
}

cpu=10
MIN=1
until [ "$COUNTER" -lt "$MIN" ];  do
    count=$(jobs | wc -l)
    if [ $(($count-$cpu)) -lt 0 ]; then
        SEED=$RANDOM
        let COUNTER-=1
        let EXPERIMENT=${FLAGS_repeats}-$COUNTER
        run_roborobo &
    fi
    sleep 2s
done

wait
