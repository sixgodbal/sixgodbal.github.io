Shader "Custom/learn_shader_texture"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color("Color",Color) = (1,1,1,1)
        _NormalMap("NormalMap",2D) = "bump"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        float4 _Color;
        sampler2D _NormalMap;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {

            o.Albedo = tex2D( _MainTex ,IN.uv_MainTex ).rgb * _Color.rgb;

            o.Normal = UnpackNormal( tex2D(_NormalMap ,IN.uv_MainTex) );

        }

        ENDCG
    }
    FallBack "Diffuse"
}
