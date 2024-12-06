# config_service.py
import json

class ConfigService:
    def __init__(self, config_file):
        self.config_file = config_file

    def load_config(self):
        with open(self.config_file, 'r') as config_file:
            config = json.load(config_file)
        return config
