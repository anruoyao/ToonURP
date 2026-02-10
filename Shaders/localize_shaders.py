#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Shader 文件汉化脚本
"""

import os
import re

# 定义替换规则
replacements = {
    # 基础属性
    '"BaseColor"': '"基础颜色"',
    '"Surface"': '"表面"',
    '"Enable Albedo Map"': '"启用反照率贴图"',
    '"Albedo"': '"反照率"',
    '"Roughness"': '"粗糙度"',
    '"Enable Roughness Map"': '"启用粗糙度贴图"',
    '"RoughnessMap"': '"粗糙度贴图"',
    '"Metallic"': '"金属度"',
    '"Enable Metallic Map"': '"启用金属度贴图"',
    '"MetallicMap"': '"金属度贴图"',
    '"Enable Normal Map"': '"启用法线贴图"',
    '"NormalMap"': '"法线贴图"',
    '"Enable Occlusion"': '"启用遮挡"',
    '"OcclusionMap"': '"遮挡贴图"',
    '"Enable Emission"': '"启用自发光"',
    '"Emission Color"': '"自发光颜色"',
    '"ShadingMode"': '"着色模式"',
    '"Mode"': '"模式"',
    '"Use HalfLambert (More Flatter)"': '"使用 HalfLambert（更平坦）"',
    '"Radiance Occlusion"': '"辐射遮挡"',
    '"Specular Color"': '"高光颜色"',
    '"Hight Color"': '"高光颜色"',
    '"Dark Color"': '"暗部颜色"',
    '"Cell Threshold"': '"色块阈值"',
    '"Cell Smoothing"': '"色块平滑"',
    '"Specular Intensity"': '"高光强度"',
    '"Specular Size"': '"高光大小"',
    '"Specular Softness"': '"高光柔和度"',
    '"Color Albedo Weight"': '"颜色反照率权重"',
    '"Scatter Color"': '"散射颜色"',
    '"Scatter Weight"': '"散射权重"',
    '"RimSettings"': '"边缘光设置"',
    '"Rim Mode"': '"边缘光模式"',
    '"DirLight Contribution"': '"方向光贡献"',
    '"Rim Color"': '"边缘光颜色"',
    '"Rim Threshold"': '"边缘光阈值"',
    '"Rim Softness"': '"边缘光柔和度"',
    '"MultLightSetting"': '"多光源设置"',
    '"Limit Addition Light Number"': '"限制额外光源数量"',
    '"Max Additional Light Number"': '"最大额外光源数量"',
    '"ShadowSetting"': '"阴影设置"',
    '"Receive Shadow Off"': '"关闭接收阴影"',
    '"RenderSetting"': '"渲染设置"',
    '"Blend Mode Preset"': '"混合模式预设"',
    '"Src Alpha"': '"源Alpha"',
    '"Dst Alpha"': '"目标Alpha"',
    '"Z Write"': '"Z写入"',
    '"Cull Mode"': '"剔除模式"',
    # ToonWater
    '"Feature"': '"特性"',
    '"Depth Max Distance"': '"深度最大距离"',
    '"Depth Gradient Shore"': '"深度渐变岸边"',
    '"Depth Disappear Shore"': '"深度消失岸边"',
    '"Fresnel Pow"': '"菲涅尔幂次"',
    '"Wave Speed"': '"波浪速度"',
    '"Normal Distort Map"': '"法线扭曲贴图"',
    '"Normal Scale"': '"法线缩放"',
    '"Normal Strength"': '"法线强度"',
    '"Skybox Texture"': '"天空盒贴图"',
    '"Underwater Distortion"': '"水下扭曲"',
    '"Caustic Scale"': '"焦散缩放"',
    # ToonStocking
    '"Stockings Pow"': '"丝袜幂次"',
    '"Color Inside"': '"内部颜色"',
    '"Color Outside"': '"外部颜色"',
    # ToonRock
    '"Snow Color"': '"雪颜色"',
    '"Snow Line (World)"': '"雪线（世界坐标）"',
    '"Grass Rock Color"': '"草地岩石颜色"',
    '"Grass Scale"': '"草地缩放"',
    '"GrassMap"': '"草地贴图"',
    # ToonHair
    '"Noise Shift Map"': '"噪点偏移贴图"',
    '"Specular Shift1"': '"高光偏移1"',
    '"Specular Shift2"': '"高光偏移2"',
    '"Specular Gloss1"': '"高光光泽度1"',
    '"Specular Gloss2"': '"高光光泽度2"',
    '"Specular Color1"': '"高光颜色1"',
    '"Specular Color2"': '"高光颜色2"',
    # ToonFace
    '"Direction Reversal"': '"方向反转"',
    '"SDF Face Map"': '"SDF面部贴图"',
    '"Face Angle Range (0~360)"': '"面部角度范围 (0~360)"',
    '"SDF Shading Softness"': '"SDF着色柔和度"',
    # ToonEye
    '"Parallax Scale"': '"视差缩放"',
    '"Mask Edge"': '"遮罩边缘"',
    '"Mask Edge Offset"': '"遮罩边缘偏移"',
    # Grass
    '"Shading"': '"着色"',
    '"Top Color"': '"顶部颜色"',
    '"Bottom Color"': '"底部颜色"',
    '"Translucent Gain"': '"半透明增益"',
    '"Shape"': '"形状"',
    '"Bend Rotation Random"': '"弯曲旋转随机"',
    '"Blade Width"': '"草叶宽度"',
    '"Blade Width Random"': '"草叶宽度随机"',
    '"Blade Height"': '"草叶高度"',
    '"Blade Height Random"': '"草叶高度随机"',
    '"Tessellation Uniform"': '"均匀细分"',
    '"Blade Forward Amount"': '"草叶前倾量"',
    '"Blade Curvature Amount"': '"草叶曲率量"',
    '"Wind"': '"风"',
    '"Wind Distortion Map"': '"风扭曲贴图"',
    '"Wind Frequency"': '"风频率"',
    '"Wind Strength"': '"风强度"',
    # Noise
    '"Noise Intensity"': '"噪点强度"',
    '"Noise Map"': '"噪点贴图"',
}

def localize_shader_file(filepath):
    """汉化单个 shader 文件"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # 按长度降序排序，避免短字符串先替换导致问题
        sorted_items = sorted(replacements.items(), key=lambda x: len(x[0]), reverse=True)
        
        for old, new in sorted_items:
            content = content.replace(old, new)
        
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✓ 已汉化: {filepath}")
            return True
        else:
            print(f"  无需修改: {filepath}")
            return False
    except Exception as e:
        print(f"✗ 错误: {filepath} - {e}")
        return False

def main():
    shader_dir = r'f:\up\admin\Packages\ToonURP\Shaders'
    
    # 获取所有 shader 文件
    shader_files = []
    for root, dirs, files in os.walk(shader_dir):
        for file in files:
            if file.endswith('.shader'):
                shader_files.append(os.path.join(root, file))
    
    print(f"找到 {len(shader_files)} 个 shader 文件\n")
    
    modified_count = 0
    for filepath in shader_files:
        if localize_shader_file(filepath):
            modified_count += 1
    
    print(f"\n{'='*50}")
    print(f"汉化完成! 共修改 {modified_count} 个文件")
    print(f"{'='*50}")

if __name__ == '__main__':
    main()
