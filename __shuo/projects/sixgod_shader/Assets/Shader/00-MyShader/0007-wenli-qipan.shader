Shader "SixGodShader/0007 wenli-qipan"
{
    Properties
    {
        _Density("Density",Range(2,50))=30
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

            struct v2f
            {
                float2 uv:TEXCOORD0;
                float4 vertex:SV_POSITION;
            };
            float _Density;
            v2f vert(float4 pos:POSITION, float2 uv:TEXCOORD0)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(pos);
                o.uv = uv * _Density;
                return o;
            }
            fixed4 frag(v2f i):SV_TARGET
            {
                float2 c = i.uv;
                c = floor(c) / 2;
                float checker = frac(c.x + c.y) * 2; //frac函数返回标量或每个矢量中各分量的小数部分。
                return checker;
            }
            ENDCG
        }
        //Properties 代码块中的密度滑动条控制棋盘的密集程度。在顶点着色器中，网格 UV 与密度值相乘，使它们从 0 到 1 的范围变为 0 到密度的范围。假设密度设置为 30，这将使片元着色器中的 i.uv 输入包含 0 到 30 的浮点值，对应于正在渲染的网格的各个位置。
        //然后，片元着色器代码仅使用 HLSL 的内置 floor 函数获取输入坐标的整数部分，并将其除以 2。回想一下，输入坐标是从 0 到 30 的数字；这使得它们都被“量化”为 0、0.5、1、1.5、2、2.5 等等的值。输入坐标的 x 和 y 分量都完成了此操作。
        //接下来，我们将这些 x 和 y 坐标相加（每个坐标的可能值只有 0、0.5、1、1.5 等等），并且只使用另一个内置的 HLSL 函数 frac 来获取小数部分。结果只能是 0.0 或 0.5。然后，我们将它乘以 2 使其为 0.0 或 1.0，并输出为颜色（这分别产生黑色或白色）。
    }
}