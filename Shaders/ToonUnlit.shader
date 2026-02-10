Shader "ToonURP/ToonUnlit"
{
    Properties
    {
        _BaseColor("基础颜色", Color) = (1, 1, 1, 1)
        // Surface
        [Main(Surface, _, off, off)] _SurfaceGroup("表面", Float) = 0
        [SubToggle(Surface, _ALBEDOMAP)] _EnableAlbedoMap("启用反照率贴图", Float) = 0.0
        [Tex(Surface_ALBEDOMAP)] [ShowIf(_EnableAlbedoMap, Equal, 1)] _MainTex ("反照率", 2D) = "white" {}

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
            Name "Toon Unlit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            Cull [_Cull]

            HLSLPROGRAM
            #pragma vertex ToonUnlitPassVertex
            #pragma fragment ToonUnlitPassFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _ALBEDOMAP

            // -------------------------------------
            // Universal Pipeline keywords

            // -------------------------------------
            // Global Material keywords

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

            #include "Packages/com.reubensun.toonurp/Shaders/ToonUnlitInput.hlsl"

            void PreProcessMaterial(inout InputData inputData, inout ToonSurfaceData surfaceData, float2 uv)
            {
            }

            #include "Packages/com.reubensun.toonurp/Shaders/ToonUnlitPass.hlsl"
            ENDHLSL
        }
    }
    CustomEditor "LWGUI.LWGUI"
}
