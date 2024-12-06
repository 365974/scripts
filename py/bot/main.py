# main.py
from bot_service import BotService
from config_service import ConfigService

if __name__ == "__main__":
    config_service = ConfigService('config.json')
    config = config_service.load_config()
    token = config['token']

    bot_service = BotService(token)
    bot_service.start()
