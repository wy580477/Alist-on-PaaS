## 考虑免费数据库都不长久，做了存档本库的决定。


**2023-4-2之前的部署请注意，README说明中"DATABASE_URL"被我手误写成"DATEBASE_URL"，请及时更改变量名（无需重新部署，但需要从头重新设置），不然容器重启后会丢失所有设置。**

## 鸣谢

- [alist-org/alist](https://github.com/alist-org/alist)
- [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)

## 概述

本项目用于在 PaaS 平台上部署 Alist，支持 CI/CD 和拉取容器镜像两种部署方式，并集成了 Aria2。

## 注意

 1. **请勿滥用，PaaS 平台账号封禁风险自负**
 2. 容器的文件系统是临时性的，重启会恢复到部署时状态。不适合长期下载和共享文件用途。
 3. Aria2 配置文件默认限速5MB/s。如果需要修改 Aria2 配置，请 Fork 后自行修改 content 目录下 `aria2.conf` 文件。

## 变量

对部署时设定的变量做如下说明。

| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `DATABASE_URL` | `` | 数据库连接 URL，默认留空为使用本地 sqlite 数据库 |
| `SITE_URL` | `` | 网站URL，比如 https://example.com ，这个地址会在 Alist 程序中的某些地方使用，如果不设置这个字段，一些功能可能无法正常工作。 |
| `TZ` | `UTC` | 时区，国内时区为 Asia/Shanghai。 |

更多变量及说明请参考：

https://github.com/alist-org/alist/blob/main/internal/conf/config.go

https://alist.nn.ci/zh/config/configuration.html

## 数据持久化

有两种解决方法：

1. 在支持持久存储卷的 PaaS 平台上（Northflank 等），可以使用默认的 SQLite 数据库，需要将持久存储卷挂载到 "/data" 目录下 。

2. 在不支持持久存储卷的 PaaS 平台上（Koyeb 等），需要连接 MySQL 或是 PostgreSQL 数据库。

**bit.to 将于 2023.6.29 停止服务**

<details>
<summary><b>  planetscale.com 免费 MySQL 数据库</b></summary>

1. 前往 https://planetscale.com 注册账号，并新建一个数据库。
2. 点击数据库名称，进入数据库管理页面，点击左侧的 "Get connection strings"，在 "connect with" 下拉菜单中选择 Symfony。
3. 下方 "mysql://" 开头字符串即为数据库连接 URL。密码只会显示一次，如果忘记保存了可以点击 "New password" 重新生成。
</details> 

<details>
<summary><b> elephantsql 免费 PostgreSQL 数据库</b></summary>

1. 前往 https://www.elephantsql.com 注册账号，并新建一个数据库。
2. 点击数据库名称，进入数据库管理页面，右侧的 Details 下方，复制 "URL" 项即为数据库连接 URL。
</details>


## 部署方式

**请勿使用本仓库直接部署**

 <details>
<summary><b>Heroku 部署方法</b></summary>

**Heroku 已于2022年11月末关闭免费服务**

 1. 点击本仓库右上角Fork，再点击Create Fork。   
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。   
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。  
 4. 用户名以 `example` 为例，项目名以 `demo` 为例
 5. 登陆heroku后，浏览器访问 dashboard.heroku.com/new?template=<https://github.com/example/demo>   
 
 </details> 
 
  <details>
<summary><b>支持 CI/CD 平台（Render，Northflank，Doprax等）部署方法</b></summary>
 
 1. 点击本仓库右上角Fork，再点击Create Fork。
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。
 4. 在 PaaS 平台管理面板中连接你新建立的 github 仓库。
 5. 按下文变量部分设置所需的变量，如果需要设置内部 HTTP 端口，默认为3000，也可以自行设置 PORT 变量修改。
 6. 然后部署即可。

</details>

 <details>
<summary><b>支持拉取容器镜像 PaaS 平台（Koyeb，Northflank等）部署方法</b></summary>
 
 1. 点击本仓库右上角Fork，再点击Create Fork。
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。
 4. 点击仓库Settings > Actions > General，滚动到页面最下方，将Workflow permissions设置为Read and write permissions。
 5. 点击页面右侧 Create a new release，建立格式为 v0.1.0 的tag，其它内容随意，然后点击 Publish release。
 6. 大概不到一分钟后，github action 构建容器镜像完成，点击页面右侧 Packages, 再点击进入刚生成的 Package。
 7. 点击页面右侧 Package settings，在页面最下方点击 Change visibility，选择 public 并输入 package 名称以确认。
 8. 容器镜像拉取地址在 package 页面 docker pull 命令示例中，其它部署步骤请参阅具体平台文档。需要设置的环境变量见下文，内部监听端口默认为3000，也可自行设置 PORT 环境变量更改。

</details>

 <details>
<summary><b>Patr 部署方法</b></summary>
 
 1. 点击本项目网页上部 Code 按钮，再点击 Create codespace on main。
 
 ![image](https://user-images.githubusercontent.com/98247050/212817236-c5a882b1-6b5b-4a6f-b8c1-c702664a9ab1.png)

 2. 点击 Patr 管理面板左侧 Docker Repository，建立新 Repo。
 
 ![image](https://user-images.githubusercontent.com/98247050/212814426-befa43d4-2e37-4147-95d5-4104f80968b8.png) 
 
 3. 点击进入 Patr 新建立的 Repo，页面最下方有三条命令：
 
 ![image](https://user-images.githubusercontent.com/98247050/212815117-37089ede-50a7-4c36-9872-bdface591071.png)
 
 4. 在之前打开的 Codespace 网页中，点击终端，执行上图中的三条命令，中间需要输入 Patr 账户密码。
 
 ![image](https://user-images.githubusercontent.com/98247050/212815400-843f9fbf-cbac-435e-87df-01b502be3017.png)

 5. 回到 Patr 网页，点击 Infrastructure > Deployment > Create Deployment，Name 随意，Image Details 选择刚才建立的 Repo，Region 选择 Singapore。
 
 ![image](https://user-images.githubusercontent.com/98247050/212815611-c6fc58b3-9b90-40c3-8234-86e64226f821.png)

 6. 点击 NEXT STEP，Ports 设置为 3000，按下文变量部分设置好需设定的变量。
 
 ![image](https://user-images.githubusercontent.com/98247050/212816360-0df56cbf-2f05-4bf6-b677-965d699e3e0b.png)

 7. 点击 NEXT STEP，将 Horizontal Scale 拉到最左侧，直到价格显示 Free，然后点击 CREATE。 
 
 ![image](https://user-images.githubusercontent.com/98247050/212816479-3b10d285-8530-4732-945e-a25c0a52648a.png)

 8. 点击 Infrastructure > Deployment，点击 START 即启动容器，点击 PUBLIC URL 获得服务域名。
 
 ![image](https://user-images.githubusercontent.com/98247050/212816900-7a3c4614-e7c3-41c1-8028-f35539280e2a.png)

</details>

## 首次使用

1. 默认用户名为 admin，密码显示在 PaaS 平台容器初次运行日志中，登录后请尽快修改密码。

2. Aria2 地址为 http://localhost:61800/jsonrpc ，RPC 密钥为空。
