<p align="center">
<img src="https://github.com/wysockipiotr/deep-scanner/blob/assets/img/icon.png" width="128" />
</p>

<h1 align="center">DeepScanner</h1>
<h5 align="center">Document scanner with autoencoder-driven defect removal (work in progress)</h5>
<br/>
<p align="center">
<img src="https://github.com/wysockipiotr/deep-scanner/blob/assets/img/mobile_gif_1.gif" width="256" />
</p>

#### Repo structure

```
+-- 
   +-- doc
   +-- api              (REST API serving the model)
   +-- mobile           (document scanner app using deep denoising autoencoder)
   +-- research         (research on denoising images using deep learning)  
      +-- datasets          (training / testing datasets)
      +-- models
      +-- notebooks
      +-- scripts
         +-- scanner    (matplotlib document scanner)
   +-- README.md
    ...
```

#### matplotlib scanner
```sh
python scripts/scanner --image <path_to_image> --output <saved_scan_path>
```
