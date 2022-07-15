Shader "Custom/Unlit/Dither"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PatternTex ("Color Palette Texture", 2D) = "white" {}
        _Gain ("Gain", Range(0,2)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
            sampler2D _PatternTex;
            float4 _PatternTex_ST;
            float _Gain;

            static const float DITHER_MATRIX_SIZE = 4;
            static const int DITHER_MATRIX[DITHER_MATRIX_SIZE * DITHER_MATRIX_SIZE] = {
                 0,  8,  2, 10,
                12,  4, 14,  6,
                 3, 11,  1,  9,
                15,  7, 13,  5
            };

            // static const float DITHER_MATRIX_SIZE = 2;
            // static const int DITHER_MATRIX[DITHER_MATRIX_SIZE * DITHER_MATRIX_SIZE] = {
            //     0, 2, 3, 1
            // };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                int column = (int)(i.uv.x * _MainTex_TexelSize.z + 0.5);
                int row = (int)(i.uv.y * _MainTex_TexelSize.w + 0.5);

                float4 col = tex2D(_MainTex, i.uv);

                float b = (float)DITHER_MATRIX[((row % DITHER_MATRIX_SIZE) * DITHER_MATRIX_SIZE + column % DITHER_MATRIX_SIZE)] / (float)(DITHER_MATRIX_SIZE * DITHER_MATRIX_SIZE);
                col.x = (col.x >= b) ? col.x : 0;
                col.y = (col.y >= b) ? col.y : 0;
                col.z = (col.z >= b) ? col.z : 0;
                col.xyz *= _Gain;

                float dist = 1;
                fixed4 newcol = col;
                for (int i = 0; i < 8; i++) {
                    float u = 0.0625 + i / 8.0;
                    fixed4 pcol = tex2D(_PatternTex, float2(u, 0.5));
                    float d = distance(col, pcol);
                    if (d < dist) {
                        dist = d;
                        newcol = pcol;
                    }
                }

                UNITY_APPLY_FOG(i.fogCoord, newcol);

                return newcol;
            }
            ENDCG
        }
    }
}
