<p align="center">
<img src="https://github.com/wysockipiotr/deep-scanner/blob/assets/img/icon.png" width="128" />
</p>

<h1 align="center">DeepScanner</h1>
<h5 align="center">Document scanner with autoencoder-driven defect removal (work in progress)</h5>

<div style="text-align: center"><table><tr>
  <td style="text-align: center">
    <img src="https://github.com/wysockipiotr/deep-scanner/blob/assets/img/demo.gif" width="600" />
  </td>
  <td style="text-align: center">
    <img src="https://github.com/wysockipiotr/deep-scanner/blob/assets/img/mobile_gif_1.gif" width="256" />
  </td>
</tr></table></div>

#### Repo structure

```
+-- 
   +-- app              (document scanner app using dnn model)
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
