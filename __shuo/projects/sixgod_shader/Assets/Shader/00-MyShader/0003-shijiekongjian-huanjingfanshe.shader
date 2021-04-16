Shader "SixGodShader/0003 shijiekongjian-huanjingfanshe"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

            struct v2f{
                half3 worldRefl:TEXCOORD0;
                float4 pos:SV_POSITION;
            };
            v2f vert(float4 vertex:POSITION, float3 normal:NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                float3 worldPos = mul(unity_ObjectToWorld, vertex).xyz; //计算顶点的 世界空间位置
                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos)); //计算世界空间视图方向
                float3 worldNormal = UnityObjectToWorldNormal(normal); //世界空间法线
                o.worldRefl = reflect(-worldViewDir, worldNormal); //内置的 HLSL 函数，计算给定法线周围的矢量反射
                return o;
            }
            fixed4 frag(v2f i):SV_TARGET
            {
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldRefl); //使用反射矢量对默认反射立方体贴图进行采样
                half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR); //将立方体贴图数据解码为实际颜色
                fixed4 c = 0;
                c.rgb = skyColor;
                return c;
            }
            ENDCG
        }
    }
    //来自内置着色器变量的 unity_SpecCube0、unity_SpecCube0_HDR、Object2World 和 UNITY_MATRIX_MVP。unity_SpecCube0 包含激活的反射探针的数据。
    //UNITY_SAMPLE_TEXCUBE 是一个用于采样立方体贴图的内置宏。通常使用标准 HLSL 语法声明和 使用大多数常规立方体贴图（__samplerCUBE__ 和 texCUBE__），但 Unity 中的反射探针立方体贴图以特殊方式声明以节省采样器字段。如果您不知道这是什么，请不要担心，只需要知道：要使用 unity_SpecCube0__ 立方体贴图，必须使用 UNITY_SAMPLE_TEXCUBE 宏。
    //UnityCG.cginc 中的 UnityWorldSpaceViewDir 函数以及来自同一文件的 DecodeHDR 函数。后者用于从反射探针数据中获取实际颜色（因为 Unity 以特殊编码方式存储反射探针立方体贴图）。
    //reflect 只是一个内置的 HLSL 函数，用于计算给定法线周围的矢量反射。
}