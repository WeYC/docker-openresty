
# OpenResty 官方源码构建 Docker Openresty ARMv7

## 适用于1Panel面板，拉取此镜像可以直接在商店安装，版本号对应1Panel商店Openresty版本号，使用Actions自行编译。
## 由于 OpenResty 官方未提供 armv7l 架构镜像，所以在应用商店启用 OpenResty 前，需要手动修改 OpenResty 镜像版本。
[1Panel相关文档](https://1panel.cn/docs/v2/faq/server_architecture/#22-openresty)

## 功能特性

- ✅ ARMv7 架构支持
- ✅ ngx_brotli 压缩模块（动态编译）
- ✅ 1pwaf 空壳支持（可选）
- ✅ 性能调整和模块管理

### 1.27.1.*版本后需要删除nginx.conf一行配置
``` diff
http {
    ...

    include /usr/local/openresty/nginx/conf/conf.d/*.conf;
    include /usr/local/openresty/nginx/conf/default/*.conf;
-   include /usr/local/openresty/1pwaf/data/conf/waf.conf;
}
```

## 1pwaf 假欺骗方案 (Stub Solution)

如果不需要 1Panel 的 WAF 功能，可以使用空壳 Lua 文件来避免启动错误：

### 方法1: 复制 stub 文件到容器

```bash
# 将 1pwaf 目录复制到容器
docker cp 1pwaf/ <container_name>:/usr/local/openresty/1pwaf/

# 重启容器
docker restart <container_name>
```

### 方法2: 使用脚本创建

```bash
# 在容器内运行
docker exec -it <container_name> bash /path/to/create-1pwaf-stubs.sh
```

### 方法3: 修改 nginx.conf 删除 waf.conf 行

编辑 nginx.conf，注释或删除这一行：
```nginx
# include /usr/local/openresty/1pwaf/data/conf/waf.conf;
```

### 文件结构

```
1pwaf/
├── init.lua              # 空壳初始化文件
├── waf.lua               # 空壳 WAF 处理文件
├── log_and_traffic.lua   # 空壳日志文件
├── worker.lua            # 空壳 worker 文件
├── lib/                  # 空目录
└── data/
    └── conf/
        └── waf.conf      # WAF 配置文件
```

### 注意事项

- 使用 stub 文件后，1Panel 的 WAF 功能将不工作
- Nginx 可以正常启动，但没有 WAF 保护
- 如果需要完整 WAF 功能，请使用 1Panel 官方的 `1panel/openresty` 镜像


### [Github](https://github.com/WeYC/docker-openresty)

### [DockerHub](https://hub.docker.com/r/weycovo/openresty) weycovo/openresty:1.27.1.2-5-1-focal or weycovo/openresty:latest

### [1Panel-dev/appstore](https://github.com/1Panel-dev/appstore)

### [openresty/docker-openresty](https://github.com/openresty/docker-openresty)



