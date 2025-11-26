# Cortex XSOAR 6 Maintenance Scripts

Welcome to the **Cortex XSOAR 6 Maintenance Scripts** library.

This repository serves as a collection of Bash and Python utilities designed to automate the maintenance, troubleshooting, and resetting of **Cortex XSOAR 6** development servers. The primary focus is on BoltDB-backed installations (standard single-server deployments) commonly used in lab and proof-of-concept environments.

> [!WARNING]
> **⚠️ DEVELOPMENT USE ONLY**
>
> These scripts are **destructive** by design. They perform actions such as wiping databases, force-killing services, and flushing system logs.
> * **Do NOT** run these on a Production environment.
> * **ALWAYS** ensure you have a snapshot or backup before execution.
> * The author is not responsible for data loss resulting from the misuse of these tools.

## 📂 Script Library

### Available Tools

#### 1. `ResetXSOARDB.sh`
**Location:** Root directory
**Purpose:** A "Factory Reset" for XSOAR investigations and data.

This script completely wipes the incident and indicator databases while preserving server configuration, users, and installed content. It is ideal for resetting a lab environment between demos or test runs.

* **Auto-Detection:** Smartly identifies if data resides in standard (`/var/lib/demisto`) or nested (`/var/lib/demisto/data`) directories.
* **Docker Reset:** Restarts the Docker daemon to clear zombie containers and network artifacts.
* **Safety First:** Automatically backs up data to a timestamped folder before deletion.
* **Auto-Cleanup:** Enforces a 3-day retention policy on local backups to save disk space.

### Roadmap / Planned Tools

* **`ClearDocker.sh`**: A utility to aggressively prune unused Docker images, volumes, and networks to free up disk space on constrained VMs.
* **`LogRotator.sh`**: A helper to force-rotate and archive `server.log`, `catalina.out`, and `audit.log` when debugging heavy integrations.

## 🚀 Getting Started

### Prerequisites

* **Operating System:** Ubuntu 18.04/20.04 or RHEL 7/8 (Systemd required)
* **Cortex XSOAR:** Version 6.x
* **Database:** BoltDB (Elasticsearch deployments are **not** supported by the reset tools)
* **Access:** Root privileges (`sudo`) are required.

### Installation

Clone the repository directly to your XSOAR server (typically in `/home/demisto` or `/opt`).

```bash
git clone [https://github.com/mattheweharding/cortex-xsoar6-scripts.git](https://github.com/mattheweharding/cortex-xsoar6-scripts.git)
cd cortex-xsoar6-scripts
chmod +x *.sh
```

## 🛠️ Usage

### Resetting the Database
To reset your environment, run the script with root privileges. It will prompt for confirmation before taking any action.

```bash
sudo ./ResetXSOARDB.sh
```

## 🤝 Contributing

Contributions to expand this library are welcome! If you have a one-liner or a cleanup script that saves you time, feel free to add it.

1.  Fork the repository.
2.  Create your Feature Branch (`git checkout -b feature/MyNewScript`).
3.  Commit your Changes (`git commit -m 'Add MyNewScript'`).
4.  Push to the Branch (`git push origin feature/MyNewScript`).
5.  Open a Pull Request.

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

---
*Maintained by Matthew Harding*