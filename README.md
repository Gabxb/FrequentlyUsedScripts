# FrequentlyUsedScripts

常用脚本仓库。本地工作区 `/workspace` 与本仓库通过 `scripts/git-autosync.sh` + cron 每 15 分钟双向自动同步:本地增删自动推送到云端,云端增删自动落到本地。

---

## 运行环境快照

> 采集时间:**2026-08-30 19:17:59 +08**(Asia/Singapore)<br>
> 以下为采集时刻的静态快照,非实时数据。

### 时间与时区

| 项目 | 值 |
| --- | --- |
| 本地时间 | 2026-08-30 19:17:59 |
| 时区 | Asia/Singapore(UTC+8,`+0800`) |
| 时区配置 | `/etc/localtime` → `/usr/share/zoneinfo/Asia/Singapore` |
| 系统运行时长 | 7 小时 53 分 |

### 系统

| 项目 | 值 |
| --- | --- |
| 发行版 | Debian GNU/Linux 12 (bookworm) |
| 内核 | 6.6.116 |
| 架构 | x86_64 |
| 主机名 | `d0c6edd3-9010-4226-b1ec-fa89ab66387b` |
| Init 进程 | `firecracker-init`(microVM,无 systemd) |

### 硬件资源

| 项目 | 值 |
| --- | --- |
| CPU | Intel(R) Xeon(R) Processor |
| 核心数 | 2 |
| 内存 | 7.8 GiB(已用 7.5 GiB / 可用 269 MiB) |
| 磁盘 | 20 GB(已用 3.3 GB,占用 18%) |
| 挂载点 | `/dev/root` on `/` |

### 网络出口

| 项目 | 值 |
| --- | --- |
| 出口公网 IP | **18.139.162.245** |
| 归属运营商 | Amazon Technologies Inc. |
| 归属组织 | AWS EC2(ap-southeast-1) |
| ASN | AS16509 Amazon.com, Inc. |
| 地理位置 | Singapore / Central Singapore |
| 内网地址 | 192.168.86.77/20(eth0) |
| 默认网关 | 192.168.80.1 |
| 链路本地 | 169.254.169.252/30(eth0) |

出口 IP 由 `api.ipify.org`、`ifconfig.me`、`ipinfo.io` 三方查询结果一致确认。

### 开发环境

| 组件 | 版本 | 路径 |
| --- | --- | --- |
| OpenJDK | 17.0.20.1 (2026-08-18) | 系统默认 |
| Gradle | 8.7 | `/opt/gradle-8.7` |
| Android SDK | build-tools 34.0.0 / platform android-34 | `/opt/android-sdk` |
| adb | 1.0.41 | `/opt/android-sdk/platform-tools` |
| Go | 1.25.6 | `/go` |
| Node.js | v22.22.0 | 系统默认 |
| npm | 10.9.4 | 系统默认 |
| Python | 3.11.2 | 系统默认 |
| Git | 2.39.5 | 系统默认 |
| Bash | 5.2.15(1) | `/usr/bin/bash` |

### 自动同步

| 项目 | 值 |
| --- | --- |
| 同步脚本 | `scripts/git-autosync.sh` |
| 定时任务 | `*/15 * * * *`(每 15 分钟) |
| 日志 | `/var/log/git-autosync.log`(超 1 MB 自动截断) |
| 冲突策略 | 分叉时尝试 rebase;真冲突则回滚告警,不做破坏性操作 |

## 脚本清单

| 脚本 | 用途 |
| --- | --- |
| `scripts/git-autosync.sh` | Git 仓库双向自动同步(含双向删除同步) |
| `scripts/github-ssh-push.sh` | GitHub SSH 推送环境配置 |
| `scripts/install-android-env.sh` | APK 编译环境一键安装(JDK 17 + Gradle 8.7 + Android SDK) |

---

<div align="center">

![AIX](https://img.shields.io/badge/AIX-000000?style=for-the-badge&labelColor=000000)

### A I X

</div>


