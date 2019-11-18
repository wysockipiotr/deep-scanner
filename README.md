<h1 align="center">DeepScanner</h1>
<h5 align="center">Document scanner with autoencoder-driven defect removal (work in progress)</h5>

<p align="center">
<img src="https://github.com/wysockipiotr/deep-scanner/blob/assets/img/demo.gif" width=400 />
</p>

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
