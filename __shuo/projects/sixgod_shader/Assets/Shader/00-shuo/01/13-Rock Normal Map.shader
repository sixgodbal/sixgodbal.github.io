Shader "Liusu/13 Rock Normal Map"
{
    Properties{
        //_Diffuse("Diffuse", Color) = (1,1,1,1)
        _Color("Color",Color) = (1,1,1,1)
        _MainTex("Main Tex", 2D) = "white"{}
        _NormalMap("Normal Map", 2D) = "bump"{} //bump模型自带贴图
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
            sampler2D _NormalMap;
            float4 _NormalMap_ST; //_ST获取到偏移值和缩放
            
            struct a2v{
                float4 vertex : POSITION;
                //模型内的 法线和切线 来确定 切线空间
                float3 normal : NORMAL;
                float4 tangent : TANGENT; //tangent.w是用来确定切线空间中座标轴的方向
                float4 texcoord : TEXCOORD0;
            };
            struct v2f {
                float4 svPos : SV_POSITION;
                float3 lightDir : TEXCOORD0; //切线空间下 平行光的方向
                float4 worldVertex : TEXCOORD1;
                float4 uv : TEXCOORD2; //xy 用来存储_MainTex纹理坐标  zw 用来存储_NormalMap纹理坐标
            };
            v2f vert(a2v v){
                v2f f;
                f.svPos = UnityObjectToClipPos(v.vertex);
                
                f.worldVertex = mul(v.vertex, unity_WorldToObject);
                f.uv.xy = v.texcoord.xy * _MainTex_ST.xy - _MainTex_ST.zw;//_MainTex_ST.zw偏移  _MainTex_ST.xy缩放
                f.uv.zw = v.texcoord.xy * _NormalMap_ST.xy - _NormalMap_ST.zw;
                return f;
            }
            //所有跟法线方向有关的运算都放在切线空间下
            //从法线贴图取得的法线方向在切线空间下
            fixed4 frag(v2f f) : SV_TARGET
            {
                fixed4 normalColor = tex2D(_NormalMap, f.uv.zw);//法线贴图颜色

                fixed3 tangentNormal = (normalColor.xyz * 2 -1); //切线空间下的法线 [x * 2 - 1] 转换 [(y + 1) / 2]

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