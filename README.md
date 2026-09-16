# 玩客云 1Panel OpenResty（Armv7 自用镜像）

基于 OpenResty 官方源码构建的 Armv7 架构 Docker 镜像，适用于玩客云等 32 位 ARM 设备上的 1Panel。

## 支持版本

| 版本 | OpenResty | OpenSSL | PCRE | 状态 |
|------|-----------|---------|------|------|
| `1.21.4.3-3-3-focal` | 1.21.4.3 | 1.1.1w | PCRE 8.45 | 支持 |
| `1.27.1.2-5-1-focal` | 1.27.1.2 | 3.4.1 | PCRE2 10.44 | 支持 |

## 使用方法

### 步骤一：替换镜像

在 1Panel 应用商店安装 OpenResty 时，选择对应版本，然后编辑 compose 文件替换镜像地址：

```diff
# 1.27.1.2 版本
-  image: 1panel/openresty:1.27.1.2-5-1-focal
+  image: weycovo/openresty:1.27.1.2-5-1-focal

# 1.21.4.3 版本
-  image: 1panel/openresty:1.21.4.3-3-3-focal
+  image: weycovo/openresty:1.21.4.3-3-3-focal
```

### 步骤二：修复模块目录（解决"模块目录缺失"报错）

新版 1Panel 需要 `module.catalog.json` 文件来识别可用模块。执行以下命令：

```bash
# 替换为你的 1Panel OpenResty 安装路径
# 1.27 版本示例
INSTALL_DIR="/opt/1panel/apps/openresty/1.27.1.2-5-1-focal"

# 1.21 版本示例
# INSTALL_DIR="/opt/1panel/apps/openresty/1.21.4.3-3-3-focal"

# 复制模块目录文件
curl -fsSL https://raw.githubusercontent.com/WeYC/docker-openresty/main/1panel/module.catalog.json \
  -o "${INSTALL_DIR}/build/module.catalog.json"

# 重启 OpenResty 容器
docker restart 1Panel-openresty
```

### 步骤三（可选）：参考官方文档

详见 [1Panel 相关文档](https://1panel.cn/docs/v2/faq/server_architecture/)。

## 构建说明

项目结构：
```
1.21.4.3-3-3-focal/
  build/
    Dockerfile              # OpenResty 1.21.4.3 + ngx_brotli
    module.catalog.json     # 1Panel 模块目录文件
1.27.1.2-5-1-focal/
  build/
    Dockerfile              # OpenResty 1.27.1.2 + ngx_brotli
    module.catalog.json     # 1Panel 模块目录文件
```

## 相关链接

- [GitHub 仓库](https://github.com/WeYC/docker-openresty)
- [Docker Hub](https://hub.docker.com/r/weycovo/openresty)（标签：`weycovo/openresty:1.27.1.2-5-1-focal` / `weycovo/openresty:1.21.4.3-3-3-focal` / `weycovo/openresty:latest`）
- [1Panel-dev/appstore](https://github.com/1Panel-dev/appstore)
- [openresty/docker-openresty](https://github.com/openresty/docker-openresty)
