import os
import json
import device
import data_generation
from models.architectures.simple_mlp import SimpleMLP

MODEL_SAVE_PATH = "saved_models"

registry = {
	"simple_mlp": SimpleMLP
}

loaded_model = None

def load_model(reference: str):
	return reference

def save_model():
	print("Saving loaded model")

def inference(data: dict):
	print("Running inference on model ")

def train_model(data: dict):
	user_set = data["set"]
	print(f"user set length: {len(user_set)}")

	ai_set = data_generation.generate_data(len(user_set))
	print(ai_set)
	print(f"ai set length: {len(ai_set)}")
	pass

def save_metadata(reference: str, architecture: str):
	print(f"Saving metadata for model {reference}")
	metadata = {
		"architecture": architecture
	}
	model_folder = f"{MODEL_SAVE_PATH}/{reference}"
	os.makedirs(model_folder, exist_ok=True)
	path = f"{model_folder}/metadata.json"
	with open(path, "w") as f:
		json.dump(metadata, f)
		print(f"Saved model metadata to {path}")