Shader "Hidden/learn_shader_alpha1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Alpha("a",Range(0,1)) = 0
    }
    SubShader
    {

        Pass
        {
            AlphaTest Greater[_Alpha] // 透明度>_Alpha

            SetTexture[_MainTex]{
                combine texture * previous
            }
        }
    }
}
