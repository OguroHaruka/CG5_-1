Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _Color("Color",Color) = (1,0,0,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #include "Lighting.cginc"

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPosition : TEXCOORD1;
                float3 normal : NORMAL;
            };

            fixed4 _Color;

            float4 vert(float4 v:POSITION):SV_POSITION
            {
                float4 o;
                o = UnityObjectToClipPos(v);
                return o;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.normal = normalize(i.normal);
                float intensity = saturate(dot(normalize(i.normal),_WorldSpaceLightPos0));
                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                float3 lightDir = normalize(_WorldSpaceLightPos0);
                float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal,lightDir);

                fixed4 diffuse=_Color * intensity * _LightColor0;
                fixed4 ambient = _Color * 0.3 * _LightColor0;
                fixed4 specular = pow(saturate(dot(reflectDir,eyeDir)),20) * _LightColor0;

                fixed4 phong = ambient + diffuse + specular;
                return phong;
            }
            ENDCG
        }
    }
}
