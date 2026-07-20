# WSL Emulator Setup Guide

This guide explains how to set up the emulator as a Windows Subsystem for Linux (WSL) distribution. It consists of three main phases: building the Docker image on Linux, exporting it to Windows, and importing it into WSL 2.

---

## Prerequisites

- **Ubuntu 24 or later** with Docker installed and running
- **Windows 10/11** with WSL 2 support
- Sufficient disk space for the Docker image and root filesystem export

---

## Phase 1: BUILD THE DOCKER IMAGE (Ubuntu/Linux)

### Step 1.1: Build the Docker image

```bash
docker build -t emu-qt6:latest .
```

This command will:
- Read the `Dockerfile` in the current directory
- Build a Docker image named `emu-qt6` with the `latest` tag
- Include the emulator and all dependencies

### Step 1.2: Verify the image was created

```bash
docker images | grep emu-qt6
```

---

## Phase 2: EXPORT THE CONTAINER (Ubuntu/Linux)

### Step 2.1: Create a container from the Docker image

```bash
docker create --name emuqt6-wsl emu-qt6:latest
```

### Step 2.2: Export the container as a root filesystem

```bash
docker export emuqt6-wsl -o emuqt6-rootfs.tar
```

This creates a compressed archive of the entire filesystem (~1-2 GB depending on image size).

### Step 2.3: Verify that the file was created

```bash
ls -lh emuqt6-rootfs.tar
```

---

## Phase 3: TRANSFER TO WINDOWS

### Step 3.1: Copy the root filesystem to Windows

Copy the file `emuqt6-rootfs.tar` to the following path on Windows:

```
C:\WSLImages\emuqt6-rootfs.tar
```

Create the `C:\WSLImages\` directory first if it does not exist.

---

## Phase 4: IMPORT INTO WSL 2 (Windows PowerShell)

### Step 4.1: Create a directory for the WSL distro

```powershell
mkdir C:\WSL\emu-qt6
```

### Step 4.2: Import the root filesystem as a WSL 2 distribution

```powershell
wsl --import emu-qt6 C:\WSL\emu-qt6 C:\WSLImages\emuqt6-rootfs.tar --version 2
```

This will:
- Create a new WSL 2 distribution named `emu-qt6`
- Store it in `C:\WSL\emu-qt6`
- Import the root filesystem from the tar archive

### Step 4.3: Verify that the distribution exists and is WSL 2

```powershell
wsl -l -v
```

You should see `emu-qt6` listed with VERSION 2.

### Step 4.4: Launch the distribution

```powershell
wsl -d emu-qt6
```

---

## Reference Files

- `configure-wsl-runtime.sh` - Runtime configuration script executed when WSL starts
- `Dockerfile` - Docker image definition for the emulator environment
- `emu-wsl-setup.service` - systemd service for WSL initialization
- `wsl.conf` - WSL-specific configuration file

---

## Backup: Export WSL Distribution from Windows

If you want to back up the `emu-qt6` distribution or transfer it to another machine:

### Step 1: Create a directory for the backup

```powershell
mkdir C:\WSLImages
```

### Step 2: Export the WSL distribution as a backup file

```powershell
wsl --export emu-qt6 C:\WSLImages\Backup-emu-qt6.wsl
```

This creates a `.wsl` archive of the entire distribution that can be re-imported later using `wsl --import`.

---

## Troubleshooting: Removing WSL Distribution

If you need to remove the WSL distribution or reinstall it, follow these steps:

### Step 1: List all WSL distributions

```powershell
wsl -l -v
```

This will show all installed distributions and their versions.

### Step 2: Shutdown WSL (if running)

```powershell
wsl --shutdown
```

This stops all running WSL instances and releases resources.

### Step 3: Unregister the emu-qt6 distribution

```powershell
wsl --unregister emu-qt6
```

This removes the `emu-qt6` distribution completely. **Warning: This deletes all files in the distribution.**

### Step 4: Verify removal

```powershell
wsl -l -v
```

The `emu-qt6` distribution should no longer appear in the list.


This installs and launches a fresh Ubuntu distribution.
