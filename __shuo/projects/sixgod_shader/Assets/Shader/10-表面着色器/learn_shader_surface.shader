Shader "Custom/learn_shader_surface"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        struct Input
        {
            float2 uv_MainTex;
        };

        float4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = _Color.rgb;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
