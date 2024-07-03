Shader "Unlit/TexturePhong"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 tiling = _MainTex_ST.xy;
                float2 offset = _MainTex_ST.zw;
                fixed4 col = tex2D(_MainTex, i.uv * tiling + offset);

                i.normal = normalize(i.normal);
                float intensity = saturate(dot(normalize(i.normal),_WorldSpaceLightPos0));
                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                float3 lightDir = normalize(_WorldSpaceLightPos0);
                float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal,lightDir);

                fixed4 diffuse=col * intensity * _LightColor0;
                fixed4 ambient = col * 0.3 * _LightColor0;
                fixed4 specular = pow(saturate(dot(reflectDir,eyeDir)),20) * _LightColor0;

                fixed4 phong = ambient + diffuse + specular;
                return phong;
            }
            ENDCG
        }
    }
}
