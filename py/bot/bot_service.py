# bot_service.py
import telebot
import json

class BotService:
    def __init__(self, token):
        self.token = token
        self.bot = telebot.TeleBot(self.token)
        self.user_states = {}

    def start(self):
        @self.bot.message_handler(commands=['start', 'help'])
        def send_welcome(message):
            chat_id = message.chat.id
            if chat_id not in self.user_states:
                self.user_states[chat_id] = {'state': 'start'}
            self.bot.reply_to(message, "Привет! Я твой бот.")

        @self.bot.message_handler(func=lambda message: True)
        def handle_messages(message):
            chat_id = message.chat.id
            user_state = self.user_states.get(chat_id, {'state': 'start'})

            if user_state['state'] == 'start':
                self.bot.reply_to(message, "Вы находитесь в начальном состоянии.")
            elif user_state['state'] == 'other_state':
                self.bot.reply_to(message, "Вы находитесь в другом состоянии.")

        self.bot.polling(none_stop=True)
