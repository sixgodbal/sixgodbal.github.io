Shader "Custom/learn_shader02"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color",Color) = (1,1,1,1)
    }
    SubShader
    {

        Lighting On
        Material{
            Diffuse[_Color]
            Ambient[_Color]
        }

        Pass
        {
            SetTexture[_MainTex]{
                combine Texture * Previous
            }
        }
    }
}
