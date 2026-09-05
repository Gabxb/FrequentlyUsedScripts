# FrequentlyUsedScripts

常用运维与开发环境脚本集合。仓库内脚本均为幂等设计,可重复执行。

本地工作区 `/workspace` 与本仓库通过 `scripts/git-autosync.sh` + cron 每 15 分钟双向自动同步:本地增删自动推送到云端,云端增删自动落到本地。

---

## 快速开始

### 交互式菜单(推荐)

列出所有脚本,输入序号选择执行:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Gabxb/FrequentlyUsedScripts/master/setup.sh)
```

### 直接运行指定脚本(适合自动化,无需交互)

```bash
curl -fsSL https://raw.githubusercontent.com/Gabxb/FrequentlyUsedScripts/master/setup.sh | bash -s -- install-android-env
```

可选脚本名:`install-android-env`、`github-ssh-push`、`git-autosync`。

### 仅查看可用脚本

```bash
curl -fsSL https://raw.githubusercontent.com/Gabxb/FrequentlyUsedScripts/master/setup.sh | bash -s -- --list
```

### 已克隆到本地时

```bash
bash setup.sh              # 交互式菜单
bash setup.sh --list       # 列出脚本
bash setup.sh git-autosync # 直接执行
```

`setup.sh` 下载脚本前会校验 HTTP 状态与 shebang,404 页面或空内容不会被当作脚本执行;标记为需要 root 的脚本在非 root 环境下会提前中止。

---

## 脚本清单

| 脚本 | 说明 | 需要 root |
| --- | --- | --- |
| `setup.sh` | 一键使用入口:菜单选择或按名直接执行下列脚本 | 视所选脚本而定 |
| `scripts/install-android-env.sh` | APK 编译环境一键安装(JDK 17 + Gradle 8.7 + Android SDK 34) | 是 |
| `scripts/github-ssh-push.sh` | GitHub SSH 推送环境配置 | 否 |
| `scripts/git-autosync.sh` | Git 仓库双向自动同步(含双向删除同步) | 否 |

### scripts/git-autosync.sh 同步行为

| 两端状态 | 行为 |
| --- | --- |
| 一致 | 无操作 |
| 本地有变更(含删除) | `git add -A` → 提交 → 推送 |
| 仅云端领先(含删除) | 快进拉取,云端删除随之落到本地 |
| 分叉、改动不冲突 | `git rebase` 自动合并后推送 |
| 分叉、真冲突 | `rebase --abort` 回滚 + 记录日志 + 非 0 退出,不做破坏性操作 |

提交前会扫描暂存文件名,命中 `.env`、`*.pem`、`*.key`、`id_rsa`/`id_ed25519`、`.netrc`、`credentials` 等模式时取消暂存并中止,避免密钥被自动推送进 Git 历史。

---

## 运行环境快照

> 采集时间:**2026-09-05 17:09 +08**(Asia/Singapore)<br>
> 静态快照,不会自动更新。

### 时间与时区

| 项目 | 值 |
| --- | --- |
| 时区 | Asia/Singapore(UTC+8,`+0800`) |
| 时区配置 | `/etc/localtime` → `/usr/share/zoneinfo/Asia/Singapore` |
| 系统运行时长 | 1 天 2 小时 30 分 |

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
| CPU | Intel(R) Xeon(R) Processor × 2 |
| 内存 | 7.8 GiB(已用 7.5 GiB / 可用 282 MiB) |
| 磁盘 | 20 GB(已用 3.6 GB,占用 20%) |

### 开发环境

| 组件 | 版本 | 路径 |
| --- | --- | --- |
| OpenJDK | 17.0.20.1 | 系统默认 |
| Gradle | 8.7 | `/opt/gradle-8.7` |
| Android SDK | build-tools 34.0.0 / platform android-34 | `/opt/android-sdk` |
| adb | 1.0.41 | `/opt/android-sdk/platform-tools` |
| Go | 1.25.6 | `/go` |
| Node.js | v22.22.0 | 系统默认 |
| npm | 11.19.1 | 系统默认 |
| Python | 3.11.2 | 系统默认 |
| Git | 2.39.5 | 系统默认 |
| Bash | 5.2.15(1) | `/usr/bin/bash` |

### 网络出口

出口 IP **不固定**。这台机器走多出口轮换的代理链路,访问境内与境外服务经由不同出口,且境外出口会随时间更换——下表为观测记录,不代表当前值。

| 观测时间 | 境外出口 | 归属 |
| --- | --- | --- |
| 2026-09-05 17:09 | `103.156.242.194` | — |
| 2026-09-04 22:37 | `45.62.172.81` | 香港 Eons Data,AS138997,`proxy: true` |
| 2026-09-04 22:37(GitHub 视角) | `212.107.28.55` | 香港 Kirino LLC,AS41378,`proxy: true` |
| 2026-08-30 19:26 | `18.139.162.245` | AWS EC2 ap-southeast-1,AS16509,`hosting: true` |

境内出口在观测期内保持稳定:

| 项目 | 值 |
| --- | --- |
| 本机 IP(cip.cc) | `39.106.200.193` |
| 归属 | 中国 北京 · 阿里云 |
| ASN | AS37963 ALIBABA-CN-NET |

内网配置:

| 项目 | 值 |
| --- | --- |
| 内网地址 | `192.168.86.77/20`(eth0) |
| 默认网关 | `192.168.80.1` |
| 链路本地 | `169.254.169.252/30`(eth0) |

查询自身出口:

```bash
curl -fsSL https://api.ipify.org   # 境外线路
curl -fsSL https://cip.cc          # 境内线路
```

### 已知网络限制

| 现象 | 实际原因 |
| --- | --- |
| `api.github.com` 返回 403 | 匿名 REST API 限额 60 次/小时被同出口流量耗尽,非封禁。git 操作不受影响 |
| Google / ChatGPT 超时 | 本地 DNS 污染,`www.google.com` 被解析到 Facebook 的地址;用 DoH 或可信 DNS 可绕过 |
| 自动同步日志有整段空白 | microVM 被挂起,挂起期间 cron 不触发,恢复后立即补跑一次 |

### 自动同步配置

| 项目 | 值 |
| --- | --- |
| 定时任务 | `*/15 * * * *`(每 15 分钟) |
| 日志 | `/var/log/git-autosync.log`(超 1 MB 自动截断后半保留) |
| SSH 通道 | `ssh.github.com:443`,密钥 `/root/.ssh/id_ed25519_github` |
| 冲突兜底 | 环境变量 `FORCE_REMOTE_WINS=1` 时云端强制胜出(会丢弃本地未推送提交,默认关闭) |

本环境无 systemd,cron 不会开机自启,已通过 `/etc/profile.d/cron-autostart.sh` 在登录 shell 时兜底拉起。

---

<div align="center">

![AIX](https://img.shields.io/badge/AIX-000000?style=for-the-badge&labelColor=000000)

### A I X

</div>




