<h1 align="center">DeepScanner</h1>
<h5 align="center">Document scanner with autoencoder-driven defect removal (work in progress)</h5>

<div style="text-align: center"><table><tr>
  <td style="text-align: center">
    <img src="https://github.com/wysockipiotr/deep-scanner/blob/assets/img/demo.gif" width="470" />
  </td>
  <td style="text-align: center">
    <img src="https://github.com/wysockipiotr/deep-scanner/blob/assets/img/mobile2.jpg" width="200"/>
  </td>
  <td style="text-align: center">
    <img src="https://github.com/wysockipiotr/deep-scanner/blob/assets/img/mobile1.jpg" width="200" />
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
