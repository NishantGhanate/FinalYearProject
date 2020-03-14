from telegram.ext import Updater , InlineQueryHandler, CommandHandler
import logging
import telegram


class Bot:

    def __init__(self):
        self.bot = None
        self.chat_id = None

    def verifyBot(self,to):
        self.bot = telegram.Bot(token=to)
        print(to)
        try :
            self.chat_id = self.bot.get_updates()[-1].message.chat_id
            print(self.chat_id)
            if self.chat_id != None:
                return True
            else:
                return False
        except Exception as e:
            print(e)
            return False

    def sendImageTelegram(self,imagePath):
        print('Sending image = {}'.format(imagePath))
        image = open(imagePath, 'rb')
        if self.chat_id != None and imagePath != None:
            self.bot.send_photo(chat_id=self.chat_id, text='Motion captured' , photo=image)
            return True
        else:
            return False
        

if __name__ == "__main__":
    bot = Bot()
    ans = bot.verifyBot("924942230:AAFa0HXAkVOFOLlCwNh2bG_W3GtV1wCT1zQ")
    print(ans)
    ans = bot.sendImageTelegram("C:/Users/Nishant/Pictures/Camera Roll/coin.jpg")
    print(ans)
