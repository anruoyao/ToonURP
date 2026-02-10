Shader "ToonURP/ShaderToySample"
{
    Properties
    {
        _BaseColor("基础颜色", Color) = (1, 1, 1, 1)
        // Surface
        [Main(Surface, _, off, off)] _SurfaceGroup("表面", Float) = 0

        [SubToggle(Surface, _ALBEDOMAP)] _EnableAlbedoMap("启用反照率贴图", Float) = 0.0
        [Tex(Surface_ALBEDOMAP)] [ShowIf(_EnableAlbedoMap, Equal, 1)] _MainTex ("反照率", 2D) = "white" {}

        [Sub(Surface)]_Roughness("粗糙度", Range(0,1.0)) = 1.0
        [SubToggle(Surface, _ROUGHNESSMAP)] _EnableRoughnessMap("启用粗糙度贴图", Float) = 0.0
        [Tex(Surface_ROUGHNESSMAP)] [ShowIf(_EnableRoughnessMap, Equal, 1)] _RoughnessMap("粗糙度贴图", 2D) = "white" {}

        [Sub(Surface)]_Metallic("金属度", Range(0,1.0)) = 1.0
        [SubToggle(Surface, _METALLICMAP)] _EnableMetallicMap("启用金属度贴图", Float) = 0.0
        [Tex(Surface_METALLICMAP)] [ShowIf(_EnableMetallicMap, Equal, 1)] _MetallicMap("金属度贴图", 2D) = "white" {}

        [SubToggle(Surface, _NORMALMAP)] _EnableNormalMap("启用法线贴图", Float) = 0.0
        [Tex(Surface_NORMALMAP)] [ShowIf(_EnableNormalMap, Equal, 1)] _NormalMap("法线贴图", 2D) = "white" {}

        [SubToggle(Surface, _OCCLUSIONMAP)] _EnableOcclusionMap("启用遮挡", Float) = 0.0
        [Tex(Surface_OCCLUSIONMAP)] [ShowIf(_EnableOcclusionMap, Equal, 1)] _OcclusionMap("遮挡贴图", 2D) = "white" {}

        [SubToggle(Surface, _EMISSION)] _EnableEmission("启用自发光", Float) = 0.0
        [Sub(Surface)] [ShowIf(_EnableEmission, Equal, 1)] [HDR]_EmissionColor("自发光颜色", Color) = (0,0,0,1)

        // Lighting mode
        [Main(ShadingMode, _, off, off)] _ShadingModeGroup("着色模式", float) = 0
        [KWEnum(ShadingMode, CelShading, _CELLSHADING, PBRShading, _PBRSHADING, ShaderToy, _CUSTOMSHADING)] _EnumShadingMode ("模式", float) = 2
        [SubToggle(ShadingMode)] _UseHalfLambert ("使用 HalfLambert（更平坦）", float) = 0
        [SubToggle(ShadingMode)] _UseRadianceOcclusion ("辐射遮挡", float) = 0
        [Sub(ShadingMode)] _SpecularColor ("高光颜色", Color) = (1,1,1,1)
        [Sub(ShadingMode)] [HDR] _HighColor ("高光颜色", Color) = (1,1,1,1)
        [Sub(ShadingMode)] _DarkColor ("暗部颜色", Color) = (0,0,0,1)
        [Sub(ShadingMode)] [ShowIf(_EnumShadingMode, Equal, 0)] _CellThreshold ("色块阈值", Range(0.01,1)) = 0.5
        [Sub(ShadingMode)] [ShowIf(_EnumShadingMode, Equal, 0)] _CellSmoothing ("色块平滑", Range(0.001,1)) = 0.001
        [Sub(ShadingMode)] [ShowIf(_EnumShadingMode, Equal, 0)] _SpecularIntensity ("高光强度", Range(0,8)) = 1
        [Sub(ShadingMode)] [ShowIf(_EnumShadingMode, Equal, 0)] _SpecularSize ("高光大小", Range(0,1)) = 0.1
        [Sub(ShadingMode)] [ShowIf(_EnumShadingMode, Equal, 0)] _SpecularSoftness ("高光柔和度", Range(0.001,1)) = 0.05
        [Sub(ShadingMode)] [ShowIf(_EnumShadingMode, Equal, 0)] _SpecularAlbedoWeight ("颜色反照率权重", Range(0,1)) = 0
        [Sub(ShadingMode)] [ShowIf(_EnumShadingMode, Equal, 0)] _ScatterColor ("散射颜色", Color) = (1,1,1,1)
        [Sub(ShadingMode)] [ShowIf(_EnumShadingMode, Equal, 0)] _ScatterWeight ("散射权重", Range(4,20)) = 10
        [Sub(ShadingMode_CUSTOMSHADING)] _CustomFloat1 ("Circle Size",Range(0.0, 1)) = 0.2
        [Sub(ShadingMode_CUSTOMSHADING)] _CustomVector1 ("Circle Color", Color) = (1,1,1,1)


        // Rim
        [Main(Rim, _, off, off)] _RimGroup("边缘光设置", float) = 0
        [KWEnum(Rim, None, _, FresnelRim, _FRESNELRIM)] _EnumRim ("边缘光模式", float) = 0
        [Sub(Rim)] [ShowIf(_EnumRim, NEqual, 0)] _RimDirectionLightContribution("方向光贡献", Range(0,1)) = 1.0
        [Sub(Rim)] [ShowIf(_EnumRim, NEqual, 0)] [HDR] _RimColor("边缘光颜色",Color) = (1,1,1,1)
        [Sub(Rim)] [ShowIf(_EnumRim, Equal, 1)] _RimThreshold("边缘光阈值",Range(0,1)) = 0.2
        [Sub(Rim)] [ShowIf(_EnumRim, Equal, 1)] _RimSoftness("边缘光柔和度",Range(0.001,1)) = 0.01

        // MultLightSetting
        [Main(MultLightSetting, _, off, off)] _MultipleLightGroup ("多光源设置", float) = 0
        [SubToggle(MultLightSetting)] _LimitAdditionLightNum("限制额外光源数量", Float) = 0
        [Sub(MultLightSetting)] [ShowIf(_LimitAdditionLightNum, Equal, 1)] _MaxAdditionLightNum("最大额外光源数量", Range(0, 8)) = 1

        // Shadow
        [Main(ShadowSetting, _, off, off)] _ShadowSettingGroup ("阴影设置", float) = 1
        [SubToggle(ShadowSetting, _RECEIVE_SHADOWS_OFF)] _RECEIVE_SHADOWS_OFF("关闭接收阴影", Float) = 0

        // RenderSetting
        [Main(RenderSetting, _, off, off)] _RenderSettingGroup("渲染设置", float) = 0
        [Preset(RenderSetting, Toon_BlendModePreset)] _BlendMode ("混合模式预设", float) = 0
        [SubEnum(RenderSetting, UnityEngine.Rendering.BlendMode)] _SrcBlend("源Alpha", Float) = 1.0
        [SubEnum(RenderSetting, UnityEngine.Rendering.BlendMode)] _DstBlend("目标Alpha", Float) = 0.0
        [SubEnum(RenderSetting, Off, 0, On, 1)] _ZWrite("Z写入", Float) = 1.0
        [SubEnum(RenderSetting, UnityEngine.Rendering.CullMode)] _Cull("剔除模式", Float) = 2.0
    }
    SubShader
    {
        Pass
        {
            Name "Toon Wet Plane"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            Cull [_Cull]

            HLSLPROGRAM
            #pragma vertex ToonStandardPassVertex
            #pragma fragment ToonShandardPassFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _ALBEDOMAP
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local _ROUGHNESSMAP
            #pragma shader_feature_local _METALLICMAP
            #pragma shader_feature_local _OCCLUSIONMAP
            #pragma shader_feature_local _EMISSION

            #pragma shader_feature_local _CELLSHADING _PBRSHADING _CUSTOMSHADING
            #pragma shader_feature_local _ _FRESNELRIM
            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF
            #pragma shader_feature_local_fragment _SURFACE_TYPE_TRANSPARENT

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
            #pragma multi_compile _ _FORWARD_PLUS
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile_fog
            #pragma multi_compile _ LIGHTMAP_ON

            // -------------------------------------
            // Universal Pipeline keywords
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"

            #include "Packages/com.reubensun.toonurp/Shaders/ToonStandardInput.hlsl"
            #include "Packages/com.reubensun.toonurp/ShaderLibrary/SSPRInclude.hlsl"

            #define _CircleColor _CustomVector1
            #define _CircleSize _CustomFloat1

            void PreProcessMaterial(inout InputData inputData, inout ToonSurfaceData surfaceData, float2 uv)
            {
            }

            float3 circle(float2 uv)
            {
                float2 xy = uv - float2(0.5f, 0.5f);

                float d = distance(uv, float2(0.5, 0.5));
                float arcU = atan2(xy.x, xy.y) / PI;
                arcU = arcU * 0.5 + 0.5;

                int id = arcU * 256;
                float radius = 0.3;
                float val = _CircleSize * arcU;
                //绘制外圈
                float outRval = id % 2 == 0 ? -0.005 : val;
                float outR = abs(d - radius);
                float3 outRcolor = step(outR, outRval + 0.005);

                //绘制内核
                float3 inColor = 0;

                return (outRcolor + inColor) * _CircleColor.rgb;
            }

            // if you want make you own shadertoy, just modify this function
            float4 CustomFragment(InputData inputData, ToonSurfaceData toonSurfaceData, AdditionInputData additionInput)
            {
                float4 color = 0;
                float2 uv = additionInput.uv.xy;
                float3 circleColor = circle(uv);
                color.xyz = circleColor;
                return color;
            }

            #include "Packages/com.reubensun.toonurp/Shaders/ToonStandardForwardPass.hlsl"
            ENDHLSL
        }

        UsePass "Hidden/ToonURP/ToonShadowCaster/ShadowCaster"

        UsePass "Hidden/ToonURP/ToonDepthNormal/DepthNormals"
    }
    CustomEditor "LWGUI.LWGUI"
}