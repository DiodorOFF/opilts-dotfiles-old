# Orange Pi 3 LTS Network Server Project Plan (Updated)

## Hardware Overview
- **Device**: Orange Pi 3 LTS
- **Processor**: Allwinner H6
- **Memory**: 2GB RAM
- **Storage**: 
  - 64GB SD card
  - 8GB internal eMMC
- **Cooling**: GPIO-controlled fan with ON/OFF functionality (currently) with future PWM upgrade path

## Network Configuration
- **DNS Servers**: Pi-hole + Unbound (completed and functioning)
- **External IP**: 171.25.168.191 (static)
- **Timezone**: Ukraine/Kyiv
- **Network Interfaces**:
  - Ethernet (primary): 192.168.88.8
  - WiFi (secondary): 192.168.88.9
- **Network Subnet**: 192.168.88.0/24
- **Port Allocation**:
  - Ports 80 and 443 will be primarily used by Caddy reverse proxy
  - Minecraft: Default ports
  - Gitea: Default ports
  - Monitoring services: Default ports

## Deployment Approach
This project uses a hybrid deployment approach:

- **System-based installation** for core services:
  - [x] Base OS (Armbian)
  - [x] Fan control system
  - [x] Etckeeper
  - [x] Docker and Docker Compose
  - [x] Dotfiles repository

- **Docker-based deployment** for application services:
  - [x] Pi-hole + Unbound
  - [ ] Caddy
  - [ ] Gitea
  - [ ] Minecraft server
  - [ ] Prometheus + Grafana

## Software Components

### 1. Base OS
- [x] Armbian Minimal (system-based)
- [x] Latest stable version
- [x] Configured for network server operation

### 2. Network Services (Docker containers)
- [x] **Pi-hole with DNS** 
  - Domain: pihole.memedition.com
  - IP: 192.168.88.8
  - Latest Docker image
  - Using Unbound for recursive DNS resolution (mvance/unbound-rpi image for ARM compatibility)
  - Local DNS management and ad-blocking
  - DNSSEC validation enabled
  - Optimized for 2GB RAM environment
  - ISSUE RESOLVED: Architecture compatibility with ARM processor, working configuration
- [ ] **Caddy server**
  - Reverse proxy for internal services
  - Automatic HTTPS
  - External access configuration
  - Primary user of ports 80 and 443
  - No DDNS needed (static external IP)

### 3. Application Services (Docker containers)
- [ ] **Minecraft Server**
  - Vanilla with Fabric implementation
  - IP: 192.168.88.8
  - Optimized for 2GB RAM environment
  - **Migration required** (existing service)
- [ ] **Git + Gitea**
  - Domain: git.memedition.com
  - IP: 192.168.88.8
  - Configured for 2-3 users maximum
  - **Migration required** (existing service)

### 4. System Management
- [x] **Etckeeper** (system-based)
  - Track system configuration changes
  - Git backend
- [x] **Dotfiles repository** (system-based)
  - Remote configuration management
  - Bare git repository method
  - GitHub repository: git@github.com:DiodorOFF/opilts-dotfiles.git
  - SSH key configured for authentication
  - Symbolic links used to connect repository files to system locations
  - Fan control configuration stored in ~/.config/fan-control/
- [x] **Docker and Docker Compose** (system-based)
  - Container orchestration
  - Latest stable versions
  - Container volumes stored on eMMC
  - Updates performed manually
- [x] **Cooling system management** (system-based)
  - ON/OFF fan control via GPIO (BC368 transistor)
  - Temperature-based control: ON at ≥50°C, OFF at <50°C
  - wiringOP library for GPIO access
  - Implementation: 
    - Script at /opt/fan-control/fan_control.sh
    - Symbolic link from ~/.config/fan-control/fan_control.sh
    - Service at /etc/systemd/system/fan-control.service
    - Symbolic link from ~/.config/fan-control/fan-control.service
  - Future upgrade path to PWM control with MOSFET
- [ ] **Backup solution**
  - Configuration files
  - Critical data
  - ~~SD card encryption~~ (DISCARDED: Not suitable for headless server)
  - Detailed backup strategy to be determined later

### 5. Monitoring (Docker containers)
- [ ] **Prometheus**
  - Lightweight configuration
  - System metrics collection
  - MikroTik network integration
- [ ] **Grafana**
  - Visualization dashboards
  - Temperature monitoring
  - System performance metrics

## Implementation Sequence

### 1. Foundation Setup
- [x] Install Armbian Minimal on SD card
- [x] Basic system configuration
- [x] Network setup and security hardening
- [x] Configure eMMC for appropriate storage usage (using ext4)
- [x] Install and configure Docker and Docker Compose
- [x] Set up GPIO fan control with ON/OFF functionality
- [x] Implement Etckeeper for tracking system changes
- [x] Set up dotfiles repository with bare git method
- [x] Configure SSH keys for GitHub access

### 2. Network Infrastructure
- [x] Deploy Pi-hole container with Unbound
  - [x] Configure DNSSEC validation
  - [x] Set timezone to Ukraine/Kyiv
  - [x] Optimize for low memory usage
  - [x] Configure to start on system boot
  - [x] Resolve ARM architecture compatibility issues
  - [x] Successfully test DNS resolution
- [ ] Deploy Caddy container
  - [ ] Configure to use ports 80 and 443
  - [ ] Set up for external IP 171.25.168.191
- [ ] Set up reverse proxy configurations
- [ ] Configure domain routing and DNS settings
- [ ] Test DNS resolution and web server functionality

### 3. Service Deployment
- [ ] Deploy Gitea container
  - [ ] Migrate existing Gitea instance and repositories
- [ ] Configure Git repositories
- [ ] Deploy Minecraft server container with Fabric
  - [ ] Migrate existing Minecraft server data and configuration
- [ ] Optimize Minecraft for available resources
- [ ] Test all services for proper functionality

### 4. Monitoring Implementation
- [ ] Deploy Prometheus container
- [ ] Deploy Grafana container
- [ ] Configure system metrics collection
- [ ] Set up temperature monitoring for fan control
- [ ] Create dashboards for system overview
- [ ] Integrate with MikroTik network stack via SNMP

### 5. Finalization
- [ ] Security audit and hardening
- [ ] Performance optimization
- [ ] Documentation of all configurations
- [ ] Implement backup strategy
- [ ] Final testing of all systems

## Storage Plan
- **eMMC (8GB)**: System partition using ext4 filesystem
- **SD Card (64GB)**: Standard ext4 filesystem for:
  - Git repositories
  - Backups
  - ~~Encrypted with LUKS~~ (DISCARDED: Not suitable for headless server)

## Maintenance Considerations
- Regular Docker image updates
- System security patches
- Backup verification
- Performance monitoring
- Temperature management

## Resource Allocation
Given the 2GB RAM constraint:
- Reserve 256MB for base system
- Allocate 512MB for Minecraft (adjustable based on player count)
- Allocate 384MB for Pi-hole + Unbound (128MB Unbound, 256MB Pi-hole)
- Allocate 256MB for Gitea
- Allocate 256MB for Caddy
- Allocate 256MB for Prometheus + Grafana
- Leave 80MB as buffer

## DNS Server Implementation (Completed)
- **Pi-hole** + **Unbound** deployed as Docker containers
- Configured for optimal performance on Orange Pi 3 LTS
- DNSSEC validation enabled
- Ad-blocking and privacy protection active
- Local DNS records configured for internal services
- Using ARM-compatible Docker image (mvance/unbound-rpi) for Unbound
- Pi-hole successfully resolving DNS queries via Unbound
- Verified working configuration with:
  ```bash
  # Host DNS resolution
  dig @127.0.0.1 google.com  # Returns proper IP
  
  # Pi-hole to Unbound resolution
  sudo docker exec pihole dig @172.20.0.2 google.com  # Returns proper IP
  ```
- Systemd service created for automatic startup
- Pi-hole admin interface accessible at http://192.168.88.8:8080/admin

## Fan Control Implementation (Completed)
- Temperature-controlled fan system implemented
- Using wiringOP for GPIO control
- Current configuration:
  - ON/OFF control (BC368 transistor)
  - ON when temperature ≥ 50°C
  - OFF when temperature < 50°C
- Script location: /opt/fan-control/fan_control.sh (symlinked from dotfiles)
- Service: /etc/systemd/system/fan-control.service (symlinked from dotfiles)
- Dotfiles storage: ~/.config/fan-control/
- Future upgrade path:
  - PWM control with MOSFET transistor
  - Variable speed control based on temperature:
    * 0-40°C: 0% PWM (fan off)
    * 40-60°C: 30-100% PWM (linear scaling)
    * >60°C: 100% PWM (fan at full speed)

## Troubleshooting Lessons
- Docker images must be ARM-compatible (arm32v7 or arm64v8) for the Orange Pi
- Configuration paths and volume mounts must match exactly
- Always test DNS resolution directly after configuration changes
- Start with minimal configuration and add complexity gradually

## Next Steps
- Deploy Caddy reverse proxy for secure access to internal services
- Set up HTTPS for Pi-hole admin interface through Caddy
- Configure Gitea and Minecraft server containers