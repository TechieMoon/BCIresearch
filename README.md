# BCIresearch
I am working as an undergraduate research assistant at the BAIlab in Korea University Sejong Campus.

The data downloaded from the reference is a file that can be executed in MATLAB.

After downloading all the files in the [data_preparation](data_preparation) folder and running [prepare_ssvep_for_pytorch.m](data_preparation/prepare_ssvep_for_pytorch.m), the data and labels are divided into low-frequency, mid-frequency, and high-frequency bands and stored.

Following this, you should execute the [mat_to_tensor.py](data_preparation/mat_to_tensor.py) script to convert the `.mat` files into PyTorch tensor format. This step is crucial for preparing the dataset for the deep learning models.

Then, by executing the training and testing codes in the [models](models) folder, the accuracy of models on the SSVEP dataset can be measured.

## Reference

CHOI, Ga-Young, et al. A multi-day and multi-band dataset for a steady-state visual-evoked potential–based brain-computer interface. GigaScience, 2019, 8.11: giz133.

Choi G-Y, Han C-H, Jung Y-J, Hwang H-J. Supporting data for "A multi-day and multi-band dataset for steady-state visual evoked potential–based brain-computer interface". Giga Science Database 2019. http://dx.doi.org/10.5524/100660.
