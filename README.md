# quest3su_kernel_module

这是一个 **vibecoding** 项目：由 AI 协作编写，代码和文档均由 AI 辅助生成，仅用于个人自动化场景，不保证与所有 KernelSU / SukiSU 版本完全兼容。

为 Oculus Quest 3 和 Quest 3S 内核构建 KernelSU LKM 模块的 GitHub Actions 项目。

## 项目结构

- `.github/workflows/build-kernelsu-oculus.yml` — 构建工作流
- `ddk/` — Ylarod/ddk 子模块，内核模块构建工具
- `scripts/setup-ddk-local.sh` — 配置 DDK 本地模式

## 使用

在 Actions 页面运行 workflow，可指定以下输入：

| 输入 | 说明 | 默认 |
| --- | --- | --- |
| `kernelsu_repo` | KernelSU 仓库，可填 SukiSU 等兼容仓库 | `tiann/KernelSU` |
| `kernelsu_ref` | 版本 tag 或 commit SHA，留空取 latest release | 空 |
| `device` | eureka 或 panther | `eureka` |

## 产物

- `quest3su.ko` — KernelSU LKM 模块
- `ksud` — 内置 `quest3su_kernelsu.ko` 的守护进程

产物以原名 `quest3su.ko` 和 `ksud` 上传至 GitHub Release，Release tag 命名为 `<仓库名>-<版本或commit>-<device>`，仓库名取自 `kernelsu_repo` 输入，例如 `tiann/KernelSU` 对应 `KernelSU`。

设备上使用 ksud：

```bash
adb push ksud /data/local/tmp/ksud
adb shell "su -c 'chmod 755 /data/local/tmp/ksud && /data/local/tmp/ksud late-load --kmi quest3su'"
```

KMI 名统一为 `quest3su`，需显式传入，因为 Quest 3 内核 uname 不含 `android\d+` 标记。

## 内核分支

| device | 机型 | 分支 | commit |
| --- | --- | --- | --- |
| `eureka` | Quest 3 | `oculus-quest3-kernel-master` | `bbb8e0cff7f048bdf011ab3e7fd686886879d80f` |
| `panther` | Quest 3S | `oculus-quest3s-kernel-master` | `9e9747b6f029257e023f507d3046e8dc537f6af9` |
