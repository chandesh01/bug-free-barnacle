# Androidbtw

Android Phone Optimisation and Setup

## organize_files_by_extension.sh

A lightweight Bash script that organizes files into categorized folders based on their **file extensions**.
Supports **recursive mode**, **cleanup of empty folders**, and works perfectly on **Termux**, **Arch**, and **Ubuntu**.

```bash
bash organize_files_by_extension.sh [options] <directory>
```

### Options

| Flag           | Description                                      |
| -------------- | ------------------------------------------------ |
| `-r`           | Recursively organize files inside subdirectories |
| `--clean`      | Delete empty folders after organizing            |
| `-h`, `--help` | Show usage info                                  |

## optimize_android.sh

ADB cache trim and, app optimization commands similar to [galaxy app booster](https://www.google.com/search?q=samsung+app+booster)

1. Connect your Android device via USB and enable USB debugging.
2. Run the script:

```bash
bash optimize_android.sh
```

> Live status can be seen on new terminal with `adb shell top`