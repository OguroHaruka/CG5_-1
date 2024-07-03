using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sBloom : MonoBehaviour
{
    public Shader bloomShader;
    private Material bloomMat;
    private void Awake()
    {
        bloomMat = new Material(bloomShader);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture highLumiTex = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);
        RenderTexture blurTex     = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);

        Graphics.Blit(source, highLumiTex, bloomMat, 0);
        Graphics.Blit(highLumiTex, blurTex, bloomMat, 1);
        bloomMat.SetTexture("_HighLumi", blurTex);
        Graphics.Blit(source, destination, bloomMat, 2);
        RenderTexture.ReleaseTemporary(highLumiTex);
        RenderTexture.ReleaseTemporary(blurTex);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
