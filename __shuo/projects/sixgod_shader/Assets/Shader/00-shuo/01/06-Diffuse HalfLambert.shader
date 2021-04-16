// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Liusu/06 Diffuse HalfLambert"{

    Properties{
        _Diffuse("Diffuse Color",Color) = (1,1,1,1)
    }

    SubShader{
        Pass{

            Tags{"LightMode"="ForwardBase"}

            CGPROGRAM
//取得第一个直射光的颜色 _LightColor0， 第一个直射光的位置 _WorldSpaceLightPos0
#include "Lighting.cginc"
#pragma vertex vert
#pragma fragment frag
            fixed4 _Diffuse;
            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 position:SV_POSITION;
                fixed3 worldNormalDir:COLOR0;
            };

            v2f vert(a2v v)
            {
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                f.worldNormalDir = mul(v.normal, (float3x3)unity_WorldToObject);
                
                return f;
            }
            fixed4 frag(v2f f):SV_TARGET
            {

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed3 normalDir = normalize(f.worldNormalDir);

                fixed lightDir = normalize(_WorldSpaceLightPos0.xyz);//平行光：光的位置即方向
                float3 halflambert = dot(normalDir, lightDir) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * max(dot(normalDir, lightDir), 0) * _Diffuse.rgb; //取得漫反射颜色
                fixed3 tempColor = (diffuse + ambient)/1;

                return fixed4(halflambert,1);
            }
            ENDCG
        }
    }
    Fallback "VertexLit"
}