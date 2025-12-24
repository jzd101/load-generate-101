#!/bin/bash

# Chaos Loader Script
# Generates random spikes of CPU, Memory, and Disk load.

# Configuration Defaults (can be overridden by ENV)
DURATION=${TEST_DURATION_SEC:-600} # Default 10 minutes
MAX_SLEEP=${MAX_IDLE_SEC:-30}
MIN_SLEEP=${MIN_IDLE_SEC:-5}
MAX_SPIKE=${MAX_SPIKE_SEC:-15}
MIN_SPIKE=${MIN_SPIKE_SEC:-5}

# Helper function to get random number in range
get_random() {
    shuf -i $1-$2 -n 1
}

echo "=========================================="
echo "   Chaos Loader Started"
echo "   Target Duration: ${DURATION} seconds"
echo "=========================================="

START_TIME=$(date +%s)
END_TIME=$(( START_TIME + DURATION ))

while [ $(date +%s) -lt $END_TIME ]; do
    # 1. Idle Phase (Normal Operation)
    SLEEP_TIME=$(get_random $MIN_SLEEP $MAX_SLEEP)
    echo "[$(date '+%H:%M:%S')] System Normal. Idling for ${SLEEP_TIME}s..."
    sleep $SLEEP_TIME

    # Check if time is up after sleep
    if [ $(date +%s) -ge $END_TIME ]; then
        break
    fi

    # 2. Spike Phase (Abnormal Load)
    SPIKE_DURATION=$(get_random $MIN_SPIKE $MAX_SPIKE)
    SPIKE_TYPE=$(get_random 1 4) # 1=CPU, 2=VM, 3=HDD, 4=ALL

    echo "[$(date '+%H:%M:%S')] ⚠️  WARNING: SPIKE DETECTED! (${SPIKE_DURATION}s)"

    case $SPIKE_TYPE in
        1)
            echo "   -> Type: HIGH CPU LOAD"
            # Use all available CPUs
            stress-ng --cpu 0 --cpu-method all -t ${SPIKE_DURATION}s --quiet &
            ;;
        2)
            echo "   -> Type: HIGH MEMORY CONSUMPTION"
            # Consume 50% of total memory per worker, 2 workers
            stress-ng --vm 2 --vm-bytes 40% -t ${SPIKE_DURATION}s --quiet &
            ;;
        3)
            echo "   -> Type: HIGH DISK I/O"
            stress-ng --hdd 2 -t ${SPIKE_DURATION}s --quiet &
            ;;
        4)
            echo "   -> Type: CRITICAL SYSTEM OVERLOAD (CPU+MEM+DISK)"
            stress-ng --cpu 4 --vm 2 --vm-bytes 30% --hdd 2 -t ${SPIKE_DURATION}s --quiet &
            ;;
    esac

    # Wait for the spike (stress-ng) to finish before continuing loop
    wait
    echo "[$(date '+%H:%M:%S')] Spike subsided. Stabilizing..."
done

echo "=========================================="
echo "   Chaos Simulation Completed."
echo "=========================================="
