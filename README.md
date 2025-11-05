# OpenResty 官方源码构建 Docker Openresty ARMv7

## 适用于1Panel面板，拉取此镜像可以直接在商店安装，版本号对应1Panel商店Openresty版本号，使用Actions自行编译。
## 由于 OpenResty 官方未提供 armv7l 架构镜像，所以在应用商店启用 OpenResty 前，需要手动修改 OpenResty 镜像版本。
[1panel相关文档](https://1panel.cn/docs/v2/faq/server_architecture/#22-openresty)

### 1.27.1.*版本后需要删除nginx.conf一行配置
``` diff
http {
    ...

    include /usr/local/openresty/nginx/conf/conf.d/*.conf;
    include /usr/local/openresty/nginx/conf/default/*.conf;
-   include /usr/local/openresty/1pwaf/data/conf/waf.conf;
}
```


### [Github](https://github.com/WeYC/docker-openresty)

### [DockerHub](https://hub.docker.com/r/weycovo/openresty) weycovo/openresty:1.27.2.2-3-focal or weycovo/openresty:latest

### [1Panel-dev/appstore](https://github.com/1Panel-dev/appstore)

### [openresty/docker-openresty](https://github.com/openresty/docker-openresty)


