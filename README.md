# DeepScanner

#### Repo structure

```
+-- 
   +-- app              (document scanner app using dnn model)
   +-- research         (research on denoising images using deep learning)  
      +-- datasets          (training / testing datasets)
      +-- models
      +-- notebooks
      +-- scripts
         +-- scanner    (document scanner, Python script)
   +-- README.md
    ...
```

#### Scanner (Python script)
``` 
python scripts/scanner --image <path_to_image> --output <saved_scan_path>
```
