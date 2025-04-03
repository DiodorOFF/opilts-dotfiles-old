# Orange Pi 3 LTS Network Server Project Plan (Updated)

## Hardware Overview
- **Device**: Orange Pi 3 LTS
- **Processor**: Allwinner H6
- **Memory**: 2GB RAM
- **Storage**: 
  - 64GB SD card
  - 8GB internal eMMC
- **Cooling**: GPIO-controlled fan with PWM (preferred) or ON/OFF functionality

## Deployment Approach
This project uses a hybrid deployment approach:

- **System-based installation** for core services:
  - [x] Base OS (Armbian)
  - [ ] Fan control system
  - [x] Etckeeper
  - [x] Docker and Docker Compose
  - [x] Dotfiles repository

- **Docker-based deployment** for application services:
  - [ ] Pi-hole + Unbound
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
- [ ] **Pi-hole with HTTPS DNS** 
  - Domain: pihole.memedition.com
  - IP: 192.168.88.8
  - Latest Docker image
- [ ] **Unbound**
  - DNS resolver for Pi-hole
  - DNSSEC validation enabled
- [ ] **Caddy server**
  - Reverse proxy for internal services
  - Automatic HTTPS
  - External access configuration

### 3. Application Services (Docker containers)
- [ ] **Minecraft Server**
  - Vanilla with Fabric implementation
  - IP: 192.168.88.8
  - Optimized for 2GB RAM environment
- [ ] **Git + Gitea**
  - Domain: git.memedition.com
  - IP: 192.168.88.8
  - Configured for 2-3 users maximum

### 4. System Management
- [x] **Etckeeper** (system-based)
  - Track system configuration changes
  - Git backend
- [x] **Dotfiles repository** (system-based)
  - Remote configuration management
  - Bare git repository method
  - GitHub repository: git@github.com:DiodorOFF/opilts-dotfiles.git
  - SSH key configured for authentication
- [x] **Docker and Docker Compose** (system-based)
  - Container orchestration
  - Latest stable versions
- [ ] **Cooling system management** (system-based)
  - PWM fan control via GPIO
  - Temperature-based speed regulation
- [ ] **Backup solution**
  - Configuration files
  - Critical data
  - ~~SD card encryption~~ (DISCARDED: Not suitable for headless server)

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
- [ ] Set up GPIO fan control with PWM functionality
- [x] Implement Etckeeper for tracking system changes
- [x] Set up dotfiles repository with bare git method
- [x] Configure SSH keys for GitHub access

### 2. Network Infrastructure
- [ ] Deploy Pi-hole container
- [ ] Configure Unbound container for secure DNS
- [ ] Deploy Caddy container
- [ ] Set up reverse proxy configurations
- [ ] Configure domain routing and DNS settings
- [ ] Test DNS resolution and web server functionality

### 3. Service Deployment
- [ ] Deploy Gitea container
- [ ] Configure Git repositories
- [ ] Deploy Minecraft server container with Fabric
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
- Allocate 384MB for Pi-hole + Unbound
- Allocate 256MB for Gitea
- Allocate 256MB for Caddy
- Allocate 256MB for Prometheus + Grafana
- Leave 80MB as buffer

## Additional Notes
- Consider log rotation for all services to prevent storage issues
- Monitor temperature closely during initial deployment
- Test external access security thoroughly
- Scale services according to actual resource usage
