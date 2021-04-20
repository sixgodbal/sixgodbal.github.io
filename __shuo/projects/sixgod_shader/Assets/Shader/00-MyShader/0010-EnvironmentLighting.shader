//上面的示例不考虑任何环境光照或光照探针。我们来解决这个问题！
// 事实证明，我们可以通过添加一行代码来实现这一目标。环境光和光照探针数据都以球谐函数形式传递给着色器，
//__UnityCG.cginc__ include 文件 中的 ShadeSH9 函数在给定世界空间法线的情况下完成所有估算工作。
Shader "SixGodShader/0010 EnvironmentLighting"
{
    Properties{
        [NoScaleOffset] _MainTex("Texture",2D) = "white"{}
    }
    SubShader{
        Pass{
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "Lighting.cginc"

            struct v2f{
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata_base v)
            {
                v2f f;
                f.vertex = UnityObjectToClipPos(v.vertex);
                f.uv = v.texcoord;
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                f.diff = nl * _LightColor0;
                // 与先前着色器的唯一区别：
                // 除了来自主光源的漫射光照，
                // 还可添加来自环境或光照探针的光照
                // 来自 UnityCG.cginc 的 ShadeSH9 函数使用世界空间法线
                // 对其进行估算
                f.diff.rgb += ShadeSH9(half4(worldNormal, 1));
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