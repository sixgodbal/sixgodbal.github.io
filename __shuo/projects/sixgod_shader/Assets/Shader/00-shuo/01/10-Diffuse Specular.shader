// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Liusu/10 Diffuse Specular"
{
    Properties{
        _Diffuse("Diffuse", Color) = (1,1,1,1)
        _Specular("Specular", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(10, 100)) = 15
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

            fixed4 _Diffuse;
            fixed4 _Specular;
            half _Gloss; //-60000~+60000
            struct a2v{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f {
                float4 svPos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float4 worldVertex : TEXCOORD1;
            };
            v2f vert(a2v v){
                v2f f;
                f.svPos = UnityObjectToClipPos(v.vertex);
                f.worldNormal = UnityObjectToWorldNormal(v.normal);
                f.worldVertex = mul(v.vertex, unity_WorldToObject);
                return f;
            }
            fixed4 frag(v2f f) : SV_TARGET
            {
                fixed3 normalDir = normalize(f.worldNormal);
                fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldVertex));
                fixed3 diffuse = _LightColor0.rgb * _Diffuse * max(dot(lightDir, lightDir), 0);
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldVertex));
                fixed3 halfDir = normalize(lightDir + viewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(dot(normalDir, halfDir), 0), _Gloss);

                fixed3 tempColor = diffuse + specular + UNITY_LIGHTMODEL_AMBIENT.rgb;//漫+高+环境
                return fixed4(tempColor, 1);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}