# Cortex XSOAR Development Reset Script

A Bash utility to "factory reset" the Incidents and Indicators (TIM) database on a **Cortex XSOAR (BoltDB)** development server. This tool is designed for lab environments, POCs, and content developers who need a clean slate for testing without reinstalling the entire operating system.

> [!CAUTION]
> **DO NOT USE THIS IN PRODUCTION.**
> This script is destructive. It deletes all Incidents, Indicators, and Audit Logs. It stops the XSOAR and Docker services during execution.

## Features
* **Deep Clean:** Wipes all investigations (Incidents), threat intelligence data (Indicators), and system logs (`server.log`, `audit.log`).
* **Docker Flush:** Restarts the Docker daemon to kill zombie containers and flush network bridges.
* **Safety Net:** Automatically backs up deleted data to a timestamped folder before wiping.
* **Auto-Cleanup:** Enforces a 3-day retention policy on backups to save disk space.
* **Path Support:** Specifically configured for installations using the nested `/var/lib/demisto/data` structure.

## Prerequisites
* **OS:** Ubuntu / RHEL (Systemd based)
* **Database:** BoltDB (Standard single-server install). **Does not support Elasticsearch.**
* **Privileges:** Must be run as `root`.

## Installation

1.  Download the script to your XSOAR server:
    ```bash
    wget [https://raw.githubusercontent.com/YOUR_USERNAME/REPO_NAME/main/ResetXSOARDB.sh](https://raw.githubusercontent.com/YOUR_USERNAME/REPO_NAME/main/ResetXSOARDB.sh)
    ```
    *(Or create the file manually and paste the content).*

2.  Make the script executable:
    ```bash
    chmod +x ResetXSOARDB.sh
    ```

## Usage

Run the script with sudo:

```bash
sudo ./ResetXSOARDB.sh