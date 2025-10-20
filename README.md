## organize_files_by_extension.sh

A lightweight Bash script that organizes files into categorized folders based on their **file extensions**.
Supports **recursive mode**, **cleanup of empty folders**, and works perfectly on **Termux**, **Arch**, and **Ubuntu**.

### 📥 Download

```bash
curl -L -o organize_files_by_extension.sh https://raw.githubusercontent.com/chandesh01/bug-free-barnacle/refs/heads/main/organize_files_by_extension.sh
chmod +x organize_files_by_extension.sh
```


### ⚙️ Usage

```bash
bash organize_files_by_extension.sh [options] <directory>
```


### 🧩 Options

| Flag           | Description                                      |
| -------------- | ------------------------------------------------ |
| `-r`           | Recursively organize files inside subdirectories |
| `--clean`      | Delete empty folders after organizing            |
| `-h`, `--help` | Show usage info                                  |


