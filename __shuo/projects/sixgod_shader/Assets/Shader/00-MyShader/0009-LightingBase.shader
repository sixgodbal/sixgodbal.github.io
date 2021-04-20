//通常，当您需要适用于 Unity 光照管线的着色器时， 可以编写表面着色器。这样会为您完成大部分“繁重的工作”， 您的着色器代码只需要定义表面属性。
//但在某些情况下，您希望绕过标准表面着色器路径； 或者是出于性能原因，您只想支持整个光照管线的某个有限子集， 或者您想要进行“标准光照”以外的自定义。
//以下示例 将说明如何从手动编写的顶点和片元着色器获取光照数据。 查看表面着色器生成的代码（通过着色器检视面板）也是一种 很好的学习资源。
Shader "SixGodShader/0009 LightingBase"
{
    Properties{
        //[NoScaleOffset]可以为我们省掉一个变量的分配，如果不需要用到纹理Tiling和Offset，请使用[NoScaleOffset]。
        [NoScaleOffset] _MainTex("Texture", 2D) = "white"{}
    }
    SubShader{
        Pass{
            Tags{"LightMode" = "ForwardBase"}

            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "UnityLightingCommon.cginc" //_LightColor0

            struct v2f{
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR0; //漫反射光照颜色
                float4 vertex : SV_POSITION;
            };
            v2f vert(appdata_base v)
            {
                v2f f;
                f.vertex = UnityObjectToClipPos(v.vertex);
                f.uv = v.texcoord;
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);//世界空间中获取法线
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));//法线、光线(_WorldSpaceLightPos0.xyz) 的点积
                f.diff = nl * _LightColor0; // 考虑浅色因素
                return f;
            }

            sampler2D _MainTex;
            fixed4 frag(v2f f) : SV_TARGET
            {
                fixed4 col = tex2D(_MainTex, f.uv);
                col *= f.diff;
                return col;
            }
            ENDCG
        }
    }
}