# Chaos Loader Generator (Random Load Simulator)

This project is designed to generate **Fake Random Spike Utilization** (CPU, Memory, Disk I/O) on a host machine via Docker. It is intended for testing Monitoring or Alerting systems by simulating random high-load events over a 10-minute period.

## Feature Changes
- Added `chaos_loader.sh`: The main script for controlling the timing of random load generation (Spikes).
- Added `Dockerfile`: For building an environment with the `stress-ng` tool pre-installed.
- Added `docker-compose.yml`: For executing the simulation easily with a single command.

## Prerequisites
1.  **Docker** and **Docker Compose** must be installed on the machine.
    - For Ubuntu: `sudo apt install docker.io docker-compose`
2.  Internet Connection (required for building the Docker image for the first time).

## Usage Instructions

1. **Clone or Download** all files to your local machine.

2. **Start Simulation**
   Run the following command to initiate the load simulation:
   ```bash
   docker-compose up --build
   ```

3. **Monitor**
   - The terminal output will display logs indicating the type of Spike occurring (CPU/Mem/Disk) and its duration.
   - If you have a separate log collection script, you may run it in parallel (actual load will be generated on the machine's system resources).

4. **Stop**
   The program will run for 10 minutes and terminate automatically, or you can press `Ctrl+C` to stop it immediately.

## Configuration
You can customize the behavior in the `docker-compose.yml` file under the `environment` section:

| Variable | Default Value | Description |
|--------|-------------|----------|
| `TEST_DURATION_SEC` | 600 | Total test duration (seconds) |
| `MAX_IDLE_SEC` | 30 | Maximum idle time between spikes |
| `MIN_IDLE_SEC` | 5 | Minimum idle time between spikes |
| `MAX_SPIKE_SEC` | 20 | Maximum duration of a spike |
| `MIN_SPIKE_SEC` | 5 | Minimum duration of a spike |

## Sample Output

```text
chaos-loader_1  | ==========================================
chaos-loader_1  |    Chaos Loader Started
chaos-loader_1  |    Target Duration: 600 seconds
chaos-loader_1  | ==========================================
chaos-loader_1  | [10:05:01] System Normal. Idling for 12s...
chaos-loader_1  | [10:05:13] ⚠️  WARNING: SPIKE DETECTED! (8s)
chaos-loader_1  |    -> Type: HIGH CPU LOAD
chaos-loader_1  | [10:05:21] Spike subsided. Stabilizing...
chaos-loader_1  | [10:05:21] System Normal. Idling for 25s...
chaos-loader_1  | [10:05:46] ⚠️  WARNING: SPIKE DETECTED! (15s)
chaos-loader_1  |    -> Type: CRITICAL SYSTEM OVERLOAD (CPU+MEM+DISK)
```
