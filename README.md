# Chaos Loader Generator (Random Load Simulator)

โปรเจกต์นี้สำหรับสร้าง **Fake Random Spike Utilization** (CPU, Memory, Disk I/O) บนเครื่องคอมพิวเตอร์ผ่าน Docker เพื่อใช้ทดสอบระบบ Monitoring หรือ Alerting โดยจะจำลองเหตุการณ์โหลดสูงแบบสุ่ม (Random) เป็นระยะเวลา 10 นาที

## Feature Changes
- เพิ่ม `chaos_loader.sh`: Script หลักสำหรับควบคุมจังหวะการเกิด Load (Spike) แบบสุ่ม
- เพิ่ม `Dockerfile`: สำหรับสร้าง Environment ที่มีเครื่องมือ `stress-ng` พร้อมใช้งาน
- เพิ่ม `docker-compose.yml`: สำหรับรัน Simulation ได้ง่ายๆ ด้วยคำสั่งเดียว

## Prerequisites (สิ่งที่ต้องเตรียม)
1.  **Docker** และ **Docker Compose** ติดตั้งอยู่บนเครื่อง
    - สำหรับ Ubuntu: `sudo apt install docker.io docker-compose`
2.  Internet Connection (สำหรับ build docker image ครั้งแรก)

## How to use (วิธีใช้งาน)

1. **Clone หรือ Download** ไฟล์ทั้งหมดลงเครื่อง

2. **Start Simulation**
   รันคำสั่งต่อไปนี้เพื่อเริ่มจำลองโหลด:
   ```bash
   docker-compose up --build
   ```

3. **Monitor**
   - หน้าจอ Terminal จะแสดง Log การทำงานว่ากำลังเกิด Spike ประเภทไหน (CPU/Mem/Disk) และนานเท่าไหร่
   - หากคุณมี Script เก็บ Log แยกต่างหาก ให้รัน Script นั้นคู่ขนานกันไปได้เลย (Load จะเกิดขึ้นจริงบน System Resource ของเครื่อง)

4. **Stop**
   โปรแกรมจะทำงาน 10 นาทีแล้วหยุดเอง หรือกด `Ctrl+C` เพื่อหยุดทันที

## Configuration (การตั้งค่า)
คุณสามารถปรับแต่งพฤติกรรมได้ในไฟล์ `docker-compose.yml` ส่วน `environment`:

| ตัวแปร | ค่า Default | คำอธิบาย |
|--------|-------------|----------|
| `TEST_DURATION_SEC` | 600 | ระยะเวลาทดสอบรวมทั้งหมด (วินาที) |
| `MAX_IDLE_SEC` | 30 | เวลาพักสูงสุดระหว่าง Spike |
| `MIN_IDLE_SEC` | 5 | เวลาพักต่ำสุดระหว่าง Spike |
| `MAX_SPIKE_SEC` | 20 | ระยะเวลาที่ Spike เกิดขึ้นนานสุด |
| `MIN_SPIKE_SEC` | 5 | ระยะเวลาที่ Spike เกิดขึ้นสั้นสุด |

## Sample Output (ตัวอย่างการทำงาน)

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
