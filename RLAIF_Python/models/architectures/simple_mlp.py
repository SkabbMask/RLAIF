import torch.nn as nn

class SimpleMLP(nn.Module):

	def __init__(self, input_size: int, hidden_size: int, output_size: int):
		super().__init__()
		self.input_size = input_size
		self.hidden_size = hidden_size
		self.output_size = output_size

	def forward(self, x):
		pass

