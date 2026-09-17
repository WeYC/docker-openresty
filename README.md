# 玩客云 1Panel OpenResty（Armv7 自用镜像）

### 基于 OpenResty 官方源码构建的 Armv7 架构 Docker 镜像，适用于玩客云等 32 位 ARM 设备上的 1Panel。

### ⚠️ **注意**：不支持应用中的【性能调整】和【模块】功能。

## 使用方法

### 方法一：替换镜像

1. 在 1Panel 应用商店安装 OpenResty 时，版本选择 `1.27.1.2-5-1-focal`
2. 编辑 compose 文件，替换镜像地址：

    ```diff
    -  image: 1panel/openresty:1.27.1.2-5-1-focal
    +  image: weycovo/openresty:1.27.1.2-5-1-focal
    ```

### 方法二：参考官方文档

详见 [1Panel 相关文档](https://1panel.cn/docs/v2/faq/server_architecture/)。

## 相关链接

- [GitHub 仓库](https://github.com/WeYC/docker-openresty)
- [Docker Hub](https://hub.docker.com/r/weycovo/openresty)（标签：`weycovo/openresty:1.27.1.2-5-1-focal` / `weycovo/openresty:latest`）
- [1Panel-dev/appstore](https://github.com/1Panel-dev/appstore)
- [openresty/docker-openresty](https://github.com/openresty/docker-openresty)
