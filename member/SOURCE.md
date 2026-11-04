# 来源、修改与许可

上游：Renhuai123 / 紫微研究

仓库：https://github.com/Renhuai123/ziwei-doushu

固定提交：a600484a49255039d0725f1ba9e11ca81a948f97

上游代码采用MIT许可，原文保存在根目录LICENSE。中文表单、排盘算法、十二宫展示和宫位联动来自上游。RepoGo沿用原生组件，调整为排盘专用入口，中文化装饰标签，移除重复导航与不可用AI入口，配置Next原生standalone和无需图像优化的部署方式，并提供离线启停脚本。

`source/`为实际依赖关系产生的源码白名单，含修改后的MIT源码、配置、package.json及锁。运行包为Node22.21.1下构建的Next16.4.3产物；`app/node_modules/`仅包含服务运行所需的已追踪依赖。

未分发范围：上游docs、现代课程原话与图片、古籍整理摘录、解读数据集、商业网站界面、未提供的AI后台；source/不含node_modules、字体文件及旧运行包。运行副本移除了sharp与其原生图像处理模块。

Node官方发行归档：node-v22.21.1-darwin-arm64.tar.gz。

官方地址：https://nodejs.org/dist/v22.21.1/node-v22.21.1-darwin-arm64.tar.gz

本轮下载使用国内镜像，归档SHA256与nodejs.org官方SHASUMS256直接读回一致：c170d6554fba83d41d25a76cdbad85487c077e51fa73519e41ac885aa429d8af。

Node及其内含组件完整原许可见licenses/NODE-LICENSE.txt及官方归档内的许可文件。Next与其vendored组件、React、算法依赖与前端动画依赖的原始LICENSE/NOTICE位于licenses/packages；运行包索引见licenses/RUNTIME-INVENTORY.json。MIT、Apache2、BSD、ISC、CC0、BlueOak等许可各自适用于对应组件。

少数包未附独立许可文件：@next/env与Next同库MIT；client-only官方npm声明MIT、主页及问题入口指向React，本包附其原package.json与React项目完整MIT文本，保留来源关系；string-hash官方README明确CC0放弃权利，附其原README和CC0完整法律文本。Edge三个包的LICENSE来自对应固定版本官方npm归档并核对registry完整性。

图片为RepoGo在本地最终运行包中取得的原生截图；detail文件仅裁去空白，未重绘软件界面。文字由AI协助整理，所有实测范围和未测系统在文档中明确列出。

本包使用从上述官方归档直接抽取bin/node与完整LICENSE制成的最小环境归档，未修改二进制。最小归档SHA256：e4173c79b3053e13def36f354c08983e4442d65672bdc08ec9df25d591d744d0。不含npm、开发头文件或其他工具。
