import scipy.io
import torch

# Define constants for the dataset and model paths
DATA_PATH = 'C:/Users/start/Documents/dataset/SSVEPdataset.mat'  # Path to the .mat dataset file
SAVE_PATH_PREFIX = 'C:/Users/start/Documents/dataset/'  # Prefix for saving tensors

def save_tensor_data(mat, key_prefix, save_path_prefix):
    """
    Load data from MAT file, convert to tensors, and save.

    Parameters:
    - mat: Loaded .mat file
    - key_prefix: Prefix for the keys in the .mat file (e.g., 'low', 'mid', 'high')
    - save_path_prefix: Prefix for the save paths of the tensors
    """
    # Load data and labels from the MAT file
    data = torch.tensor(mat[f'{key_prefix}FrequencyData'], dtype=torch.float32)
    labels = torch.tensor(mat[f'{key_prefix}Labels'], dtype=torch.long)
    labels = labels.squeeze()  # Remove extraneous dimensions

    # Save the tensors to files
    torch.save(data, f'{save_path_prefix}FrequencyData.pt')
    torch.save(labels, f'{save_path_prefix}Labels.pt')

# Load the MAT file
mat = scipy.io.loadmat(DATA_PATH)

# Process and save low, mid, and high frequency data
for freq in ['low', 'mid', 'high']:
    save_tensor_data(mat, freq, SAVE_PATH_PREFIX + freq)
