import torch

def get_device_name():
	if torch.cuda.is_available():
		if torch.version.hip is not None:
			return "rocm"
		else:
			return "cuda"
	else:
		return "cpu"

def get_device():
	if torch.cuda.is_available():
		return torch.device("cuda")
	else:
		return torch.device("cpu")