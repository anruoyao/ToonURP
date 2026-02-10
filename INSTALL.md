# ToonURP 安装说明（UnityPackage 版本）

## 快速安装

### 方法 1：使用 UnityPackage（推荐）

1. **创建新项目**
   - 使用 Unity 2022.3 创建一个新项目（Built-in 渲染管线）

2. **导入 UnityPackage**
   - 双击 `ToonURP_Hanitized.unitypackage` 文件
   - 或者在 Unity 中选择 `Assets > Import Package > Custom Package...`
   - 选择所有内容并导入

3. **配置 URP**
   - 打开 `Window > Rendering > Render Pipeline Converter`
   - 选择 `Built-in to URP` 并转换
   - 或者手动设置：
     - `Edit > Project Settings > Graphics`
     - 将 `Scriptable Render Pipeline Settings` 设置为 `ToonURP/Settings/URP-HighFidelity.asset`

4. **完成！**
   - 现在可以开始使用 ToonURP 材质了

### 方法 2：完整包（含修改过的 URP）

如果你的项目需要修改过的 URP 功能：

1. **创建新项目**
   - 使用 Unity 2022.3 创建一个新项目

2. **导入完整包**
   - 导入 `ToonURP_Full_Hanitized.unitypackage`

3. **自动配置**
   - 包内已包含配置好的 URP 设置
   - 直接开始使用即可

## 包含内容

### ToonURP_Hanitized.unitypackage
- ✅ ToonURP 核心代码（已汉化）
- ✅ 所有 Shader（已汉化）
- ✅ LWGUI 编辑器（已汉化）
- ✅ 示例场景和资源
- ✅ 预设文件

### ToonURP_Full_Hanitized.unitypackage
- ✅ 上述所有内容
- ✅ 修改过的 URP Core
- ✅ 修改过的 URP Universal
- ✅ 修改过的 ShaderGraph

## 使用说明

### 创建材质
1. 在 Project 窗口右键点击
2. 选择 `Create > Material`
3. 在 Inspector 中选择 Shader：`ToonURP/ToonStandard`

### 主要 Shader
- `ToonURP/ToonStandard` - 标准卡通材质
- `ToonURP/ToonHair` - 头发材质
- `ToonURP/ToonFace` - 面部材质（支持 SDF 阴影）
- `ToonURP/ToonEye` - 眼睛材质
- `ToonURP/ToonStocking` - 丝袜材质
- `ToonURP/ToonWater` - 卡通水面
- `ToonURP/Grass` - 几何着色器草地

### 语言设置
- 打开 `Window > LWGUI > Localization Settings`
- 可以选择中文或英文界面

## 注意事项

1. **Unity 版本**：必须使用 Unity 2022.3 或更高版本
2. **URP 版本**：与 URP 14 兼容
3. **汉化内容**：
   - 所有 Shader 属性名称已汉化
   - LWGUI 编辑器界面已汉化
   - 预设选项已汉化

## 故障排除

### 预设文件报错
如果看到 `无效的 ShaderPropertyPreset` 错误：
1. 重启 Unity
2. 或者将 `ToonURP/Samples/Toon_BlendModePreset.asset` 复制到 `Assets/ToonURP/Resources/` 文件夹

### Shader 报错
1. 确保 Graphics Settings 中正确设置了 URP Asset
2. 尝试重新导入 Shader 文件：`右键点击 Shader 文件 > Reimport`

## 更新日志

### v1.0 (Hanitized)
- 初始汉化版本
- 完整汉化所有 Shader 属性
- 汉化 LWGUI 编辑器界面
- 添加语言切换功能

## 技术支持

如有问题，请检查：
1. Unity 版本是否为 2022.3
2. 是否正确配置了 URP
3. 是否导入了所有依赖包

---

**制作日期**：2025年2月  
**汉化作者**：基于 Jason Ma 的 LWGUI 和 Reuben-Sun 的 ToonURP
