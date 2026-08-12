import asyncio
from aiogram import Bot, Dispatcher, F
from aiogram.types import Message
from aiogram.fsm.context import FSMContext
from aiogram.fsm.state import State, StatesGroup
from aiogram.fsm.storage.memory import MemoryStorage

# ================= НАСТРОЙКИ =================
TOKEN = "8916487420:AAEsIY1K7rwRKPm2ge_lO7BQpsQ1aynol84" # Твой токен

TARGET_CHATS = [
    "@pr4kpop",
    "@chatwnr"
]

DELAY = 5  
# =============================================

bot = Bot(token=TOKEN)
dp = Dispatcher(storage=MemoryStorage())

class PostState(StatesGroup):
    waiting_for_text = State()

@dp.message(F.text == "/start")
async def start_cmd(message: Message, state: FSMContext):
    await message.answer("Привет! Отправь мне текст или пост, и я опубликую его во все группы ✨")
    await state.set_state(PostState.waiting_for_text)

@dp.message(PostState.waiting_for_text)
async def process_post(message: Message, state: FSMContext):
    user_text = message.text
    await message.answer("Начинаю отправку по чатам, подожди немного...")

    success_count = 0
    for chat in TARGET_CHATS:
        try:
            await bot.send_message(chat_id=chat, text=user_text)
            success_count += 1
            await asyncio.sleep(DELAY)
        except Exception as e:
            print(f"Ошибка при отправке в {chat}: {e}")

    await message.answer(f"Готово! Сообщение успешно отправлено в {success_count} из {len(TARGET_CHATS)} чатов 💕")
    await state.clear()

async def main():
    print("Бот запущен!")
    await bot.delete_webhook(drop_pending_updates=True)
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
