// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Liusu/11-SingleTexture"
{
    Properties{
        //_Diffuse("Diffuse", Color) = (1,1,1,1)
        _Color("Color",Color) = (1,1,1,1)
        _MainTex("Main Tex", 2D) = "white"{}
    }
    SubShader
    {
        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "Lighting.cginc"
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Specular;
            half _Gloss; //-60000~+60000
            struct a2v{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };
            struct v2f {
                float4 svPos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float4 worldVertex : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };
            v2f vert(a2v v){
                v2f f;
                f.svPos = UnityObjectToClipPos(v.vertex);
                f.worldNormal = UnityObjectToWorldNormal(v.normal);
                f.worldVertex = mul(v.vertex, unity_WorldToObject);
                f.uv = v.texcoord.xy * _MainTex_ST.xy - _MainTex_ST.zw;//_MainTex_ST.zw偏移  _MainTex_ST.xy缩放
                return f;
            }
            fixed4 frag(v2f f) : SV_TARGET
            {
                fixed3 normalDir = normalize(f.worldNormal);
                fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldVertex));

                fixed3 texColor = tex2D(_MainTex, f.uv.xy) * _Color;//图片*颜色

                fixed3 diffuse = _LightColor0.rgb * texColor * max(dot(lightDir, lightDir), 0);

                fixed3 tempColor = diffuse + UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;//漫+高+环境  环境光与图片颜色融合
                return fixed4(tempColor, 1);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}