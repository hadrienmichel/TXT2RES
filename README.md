# TXT2RES

TXT2DAT is a MATLAB GUI that enables fast and easy transcription of TXT files issued from the ABEM [Terrameter LS toolbox](https://www.guidelinegeo.com/support-service-advice-training/resource-center/?qs_product=244&qs_types=&qs_solutions=). The main advantage of the use of this function over the built-in Terrameter export functions is the ability to put a threshold on the observed variance of the data.

## Installation
To install, simply add the directory containing the TXT2DAT.m and TXT2DAT.fig files to MATLAB's current path.

## Use

1. Type ```TXT2DAT``` in MATLAB's command window. The GUI will appear.
2. Select the ```*.txt``` file containing the data **and the measurements settings**, either by clicking on the pushbutton or by entering manually the path to the file.
3. Select the threshold that you want to apply to the dataset (from an analysis of the histogram).
4. Click on the pushbutton corresponding to the format that you want.

## Supported formats
- RES2DINV: full support for 2D datasets, resistivity and IP
- RES3DINV: support for 3D datasets only in resistivity
- AARHUSINV: never tested (the formatting should correspond), only for resistivity
- CRTomo: support for 2D datasets, resistivity only
- BERT: support for 2D and 3D datasets, resistivity only

### TODO
- Add support for IP data on all the formats
- Test export in AARHUSINV format
