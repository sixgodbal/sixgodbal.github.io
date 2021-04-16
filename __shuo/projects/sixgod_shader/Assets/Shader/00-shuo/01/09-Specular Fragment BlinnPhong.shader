// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Liusu/09 Specular Fragment BlinnPhong"{

    Properties{
        _Diffuse("Diffuse Color",Color) = (1,1,1,1)
        _Specular("Specular Color", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(8,100)) = 10
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
            fixed4 _Specular;
            half _Gloss;
            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 position:SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float4 worldVertex : TEXCOORD1;
            };

            v2f vert(a2v v)
            {
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                //f.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                f.worldNormal = UnityObjectToWorldNormal(v.normal);
                f.worldVertex = mul(v.vertex, unity_WorldToObject);
                return f;
            }
            fixed4 frag(v2f f):SV_TARGET
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed3 normalDir = normalize(f.worldNormal);

                //fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//平行光：光的位置即方向
                fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldVertex).xyz);
                fixed3 diffuse = _LightColor0.rgb * max(0, dot(normalDir, lightDir)) * _Diffuse.rgb; //取得漫反射颜色

                //fixed3 refleDir = normalize(reflect(-lightDir, normalDir));//取反射光方向 根据入射方向、法线方向
                //fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - f.worldVertex); //_WorldSpaceCameraPos 摄像机位置
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldVertex));
                fixed3 halfDir = normalize(lightDir + viewDir);

                fixed3 specular = _LightColor0.rbg * _Specular.rgb * pow(max(dot(normalDir, halfDir), 0), _Gloss);

                fixed3 tempColor = diffuse + ambient + specular;

                return fixed4(tempColor,1);
            }
            ENDCG
        }
    }
    Fallback "VertexLit"
}