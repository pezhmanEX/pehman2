--Start Tabchi By@LuaError
_Config = dofile('Config.lua')
bot = _Config.bot
sudo = _Config.sudo
myusername = _Config.my
redis =  dofile('./libs/redis.lua')
color = {
black = {30, 40},
red = {31, 41},
yellow = {33, 43},
magenta = {35, 45}
}
function dl_cb(arg, data)
end
function vardump(value)
end
function is_pv(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-') then
return false
else
return true
end
end
function is_mybot(msg)
local var = false
for v,user in pairs({tonumber(sudo)}) do
if user == msg.sender_user_id then
var = true
end
end
return var
end
function is_sudo(msg)
local var = false
for v,user in pairs({tonumber(sudo)}) do
if user == msg.sender_user_id then
var = true
end
end
if redis:sismember('SUDO'..bot..'ID', msg.sender_user_id) then
var = true
end
return var
end
function leave(mili)
tdbot_function ({
["@type"] = "setChatMemberStatus",
chat_id = mili,
user_id = bot,
status = {
["@type"] = "chatMemberStatusLeft"
},
}, dl_cb, nil)
end
function is_sgp(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-100') then 
if not msg.is_post then
return true
end
else
return false
end
end
TELEGRAM = {777000,366695086}
function is_Telegram(msg)
local var = false
for v,user in pairs(TELEGRAM) do
if user == msg.sender_user_id then
var = true
end
end
return var
end
if redis:get('time'..bot..'forward') and redis:get('baner'..bot..'chat') and not redis:get('time'..bot..'auto') then
local delsan = redis:get('time'..bot..'forward')
redis:setex('time'..bot..'auto',tonumber(delsan),true)
list = redis:smembers('baner'..bot..'id')
inchat = redis:get('baner'..bot..'chat')
local fwds = redis:get('fwd'..bot..'stats') or 'spg'
local tt = redis:smembers('stats'..bot..''..fwds..'')
for k,v in pairs(tt) do
for i=1 , #list do 
tdbot_function({
["@type"] = "forwardMessages",
chat_id = v,
from_chat_id = inchat,
message_ids = {[0]= list[i]},
disable_notification = true,
from_background = true
}, dl_cb, nil)
end
end
end
function viewMessages(chat_id, message_ids)
tdbot_function ({
["@type"] = "viewMessages",
chat_id = chat_id,
message_ids = message_ids
}, dl_cb, nil)
end
function send(chat_id, msg_id, text)
function ParseModeHTML(a, b)
tdbot_function ({
["@type"] = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = true,
from_background = true,
reply_markup = nil,
input_message_content = {
["@type"] = "inputMessageText",
text= {["@type"]="formattedText", text = b.text, entities = {}},
disable_web_page_preview = true,
clear_draft = false
},
}, dl_cb, nil)
end
tdbot_function({["@type"] = "parseTextEntities", text = text, parse_mode = {["@type"]= "textParseModeHTML"}}, ParseModeHTML, nil)
end
function run(msg,data)
if msg then
viewMessages(msg.chat_id, {[0] = msg.id} )
if msg.content["@type"] == "messageText" then
msg_type = 'text'
end
if msg.content["@type"] == "messageText" then
text = msg.content.text.text
end
if redis:get('left'..bot..'channel') and (not msg.forward_info and (msg.is_channel_post == true)) then
leave(msg.chat_id)
end
------------------------------[ START BOT ]----------------------------
if text and text:match('^ارتقا (%d+)') and is_mybot(msg) then
local id = text:match('^ارتقا (%d+)')
if not (tonumber(id)==tonumber(bot)) then
redis:sadd('SUDO'..bot..'ID',id)
send(msg.chat_id,msg.id,''..id..' سودو شد📍\n'..myusername..'\n')
else
send(msg.chat_id,msg.id,'سودو شدن ربات امکان پذیر نیست📍\n'..myusername..'\n')
end
elseif text and text:match('^عزل (%d+)') and is_mybot(msg) then
local id = text:match('^عزل (%d+)')
if not (tonumber(id)==tonumber(bot)) then
redis:srem('SUDO'..bot..'ID',id)
send(msg.chat_id,msg.id,''..id..' عزل مقام شد📍\n'..myusername..'\n')
else
send(msg.chat_id,msg.id,'ربات سودو نبود📍\n'..myusername..'\n')
end
elseif text == 'لیست سودو' and is_mybot(msg) then
local list = redis:smembers('SUDO'..bot..'ID')
local LuaError = 'لیست سودو ها : \n'
for k,v in pairs(list) do 
LuaError = LuaError..k.." 》 "..v.."\n"
end
if #list == 0 then
LuaError = 'لیست خالی\n'..myusername..'\n'
end
send(msg.chat_id, msg.id,LuaError)
elseif text == 'ریلود' and is_sudo(msg) then
dofile('bot.lua')
send(msg.chat_id,msg.id,'ربات بازنگری شد✔️\n'..myusername..'\n')
elseif (text == 'بروزسازی امار' or text == 'بروزسازی آمار') and is_sudo(msg) and not redis:get('time'..bot..'res') then
redis:setex('time'..bot..'res',86400,true)
redis:del('stats'..bot..'pv')
redis:del('stats'..bot..'gp')
redis:del('stats'..bot..'sgp')
redis:del('stats'..bot..'all')
send(msg.chat_id,msg.id,'حالت باز شماری امار فعال شد\n'..myusername..'\n')
elseif text and text:match("^(تنظیم)$") and tonumber(msg.reply_to_message_id) > 0 and is_sudo(msg) then
redis:sadd('baner'..bot..'id',msg.reply_to_message_id)
redis:set('baner'..bot..'chat',msg.chat_id) 
local text = 'بنر تنطیم شد✔️\n'..myusername..'\n'
send(msg.chat_id,msg.id,text)
elseif text == "version" or text == "ورژن" then
local textmsg = [[
🔻🔻🔻🔻🔻🔻
🔹LeTabchi V2.1
🔸By @LuaError
🔹Coded By @Abolfazl_Le
🔺🔺🔺🔺🔺🔺
🔹Special Thanks To: 
🔸 @IR_MILAD ✔️
🔹 @Amir_KaLan ✔️
]]
send(msg.chat_id,msg.id,textmsg)
elseif (text == 'راهنما' or text == 'help') and is_sudo(msg) then
local txt = [[
🍃راهنمای ربات تبچی🍃
〰〰〰〰〰〰〰〰〰
♦️ارتقا ایدی عددی
🔹ارتقا کاربر به سودو ربات🔸
〰〰〰〰〰〰〰〰〰
♦️عزل ایدی عددی
🔹عزل کاربر به سودو ربات🔸
〰〰〰〰〰〰〰〰〰
♦️لیست سودو
🔹نمایش لیست سودو های ربات🔸
〰〰〰〰〰〰〰〰〰
♦️ریلود
🔹بارگذاری مجدد ربات🔸
〰〰〰〰〰〰〰〰〰
♦️بروزسازی آمار
🔹بروز رسانی کردن آمار ربات🔸
〰〰〰〰〰〰〰〰〰
♦️راهنما
🔹نمایش متن راهنمای ربات تبچی🔸
〰〰〰〰〰〰〰〰〰
♦️chat ایدی عددی 
🔹انتخاب کاربر برای چت کردن🔸
♦️send متن پیام
🔹ارسال پیام به کاربر انتخاب شده🔸
〰〰〰〰〰〰〰〰〰
♦️addall ایدی عددی
🔹اد کردن کاربر به تمامی گروهای ربات🔸
〰〰〰〰〰〰〰〰〰
♦️بنر ها
🔹نمایش بنر های تنظیم شده🔸
〰〰〰〰〰〰〰〰〰
♦️تنظیم ریپلای
🔹تنظیم بنر برای فوروارد خودکار🔸
〰〰〰〰〰〰〰〰〰
♦️on
🔹تست آنلاینی ربات🔸
〰〰〰〰〰〰〰〰〰
♦️مکث عدد به ثانیه
🔹مکث برای جوین کردن در لینک گروها🔸
〰〰〰〰〰〰〰〰〰
♦️time عدد به دقیقه
🔹تایم ارسال هر بنر🔸
〰〰〰〰〰〰〰〰〰
♦️وضعیت
🔹دریافت وضعیت ربات🔸
〰〰〰〰〰〰〰〰〰
♦️امار
🔹دریاف آمار ربات🔸
〰〰〰〰〰〰〰〰〰
♦️فوروارد سوپرگروه
🔹انتخاب نوع فوردارد به سوپرگروه فقط🔸
〰〰〰〰〰〰〰〰〰
♦️فوروارد گروه
🔹انتخاب نوع فوروارد به گروه فقط🔸
〰〰〰〰〰〰〰〰〰
♦️فوروارد پیوی
🔹انتخاب نوع فوروارد به پیوی فقط🔸
〰〰〰〰〰〰〰〰〰
♦️فوروارد به همه
🔹انتخاب نوع فوردارد به همه🔸
〰〰〰〰〰〰〰〰〰
♦️فوروارد 
🔹ارسال به نوع انتخاب شده🔸
〰〰〰〰〰〰〰〰〰
♦️جوینر روشن/خاموش
🔹خاموش و روشن کردن جوین خودکار🔸
〰〰〰〰〰〰〰〰〰
♦️ذخیره مخاطب روشن/خاموش
🔹خاموش روشن کردن ذخیره مخاطب🔸
〰〰〰〰〰〰〰〰〰
♦️حذف بنر ها
🔹حذف بنرهای تنظیم شده🔸
〰〰〰〰〰〰〰〰〰
♦️خروج
🔹خارج شدن ربات از گروه🔸
〰〰〰〰〰〰〰〰〰
♦️خروج کلی
🔹خارج شدن ربات ازتمام گروه ها🔸
〰〰〰〰〰〰〰〰〰
♦️cpu
🔹نمایش مصرف سی پیو🔸
〰〰〰〰〰〰〰〰〰
♦️ram
🔹نمایش مقدار رم🔸
〰〰〰〰〰〰〰〰〰
♦️server user
🔹نمایش یوزرهای روی سرور🔸
〰〰〰〰〰〰〰〰〰
]]
send(msg.chat_id,msg.id,txt)
elseif text and text:match('^chat (%d+)$') and is_sudo(msg) then
local id = text:match('^chat (%d+)$')
redis:set('chat'..bot..'pm',id)
redis:set('chat'..bot..'id',msg.chat_id)
send(msg.chat_id,msg.id,'> کاربر '..id..' برای چت انتخاب شد✔️\n'..myusername..'\n')
elseif text and text:match('^send (.*)$') and is_sudo(msg) then
local pm = text:match('^send (.*)$')
local chat = redis:get('chat'..bot..'pm') or 0
send(msg.chat_id,msg.id,'>پیام ارسال شد✔️\n'..myusername..'\n')
send(tonumber(chat),0,pm)
elseif text and text:match('^addall (%d+)$') and is_sudo(msg) then
local id = text:match('^addall (%d+)$')
local list = redis:smembers('stats'..bot..'sgp')
for k,v in pairs(list) do
tdbot_function ({
["@type"] = "addChatMember",
chat_id = v,
user_id = id,
forward_limit =  50
}, dl_cb, nil)
end
send(msg.chat_id,msg.id,'در حال افزودن کاربر ...!\n'..myusername..'\n')
elseif text == 'بنر ها' and is_sudo(msg) then
list = redis:smembers('baner'..bot..'id')
fromchat = redis:get('baner'..bot..'chat') 
for i=1 , #list do 
tdbot_function({
["@type"] = "forwardMessages",
chat_id = msg.chat_id,
from_chat_id = fromchat,
message_ids = {[0]= list[i]},
disable_notification = true,
from_background = true
}, dl_cb, nil)
end
if msg.content._ == "messageChatDeleteMember" and msg.content.id == bot then
redis:sadd('rem'..bot..'chat',msg.chat_id)
end 
elseif text and text:match('^مکث (%d+)') and is_sudo(msg) then
local id = text:match('^مکث (%d+)')
redis:set('time'..bot..'join',id)
send(msg.chat_id,msg.id,'مکث در عضویت '..id..' شد 📍\n'..myusername..'\n')
elseif text == 'وضعیت' and is_sudo(msg) then
local timeforward = redis:get('time'..bot..'forward') or 0
local joiners = redis:get('joiner'..bot..'stats') and 'روشن' or 'خاموش'
local fwdstats = redis:get('fwd'..bot..'stats') or 'sgp'
local links = redis:scard('link'..bot..'join')
local baners = redis:scard('baner'..bot..'id')
local sudos = redis:scard('SUDO'..bot..'ID')+1
local timejoin = redis:get('time'..bot..'join') or 200
local leave_channel = redis:get('left'..bot..'channel')
local a = io.popen("uptime -p"):read("*a")
local b = string.gsub(a,"hour","ساعت")
local c = string.gsub(b,"minutes","دقیقه")
local d = string.gsub(c,"week","هفته")
local e = string.gsub(d,"s","")
local uptime = string.gsub(e,"up","")
local tota =  io.popen("du -h /var/lib/redis/dump.rdb"):read("*a")
local totalredis = string.gsub(tota,"/var/lib/redis/dump.rdb","")
local txt = '🔸وضعیت ربات تبلیغگر🔹\n〰〰〰〰〰〰\n》مکث در عضویت : '..timejoin..'\n》جوین خودکار : '..joiners..'\n》زمان فوروارد خودکار : '..timeforward..'\n》فوردارد به : '..fwdstats..'\n》لینک در صف : '..links..'\n》 بنر ها : '..baners..'\n》تعداد سودو ها : '..sudos..'\n》 خروج از کانال: '..leave_channel..'\n📍وضعیت سرور📍\n〰〰〰〰〰〰\n》اپتایم سرور :'..uptime..'》حجم دیتابیس : '..totalredis..'\n'..myusername..'\n'
send(msg.chat_id,msg.id,txt)
elseif text == "on" then
send(msg.chat_id,msg.id,"آنلاینم📍\n"..myusername..'\n')
elseif text == "ram" then
local mem = io.popen("free"):read("*a")
send(msg.chat_id,msg.id,mem..""..myusername)
elseif text == "cpu" then
local cpu = io.popen(" cat /proc/cpuinfo"):read("*a")
send(msg.chat_id,msg.id,cpu..""..myusername)
elseif text == "server user"then
local user = io.popen("ls /home"):read("*a")
send(msg.chat_id,msg.id,"♦️یوزرهای فعال بر روی سرور♦️ \n"..user..""..myusername..'\n')
elseif text and text:match('^time (%d+)') and is_sudo(msg) then
local ttime = text:match('^time (%d+)')
redis:set('time'..bot..'forward',ttime*60)
send(msg.chat_id,msg.id,'> تایم فوروارد خودکار '..ttime..' دقیقه تنظیم شد✔️\n'..myusername..'\n')
elseif (text == 'امار' or text == 'آمار') and is_sudo(msg) then
local pv = redis:scard('stats'..bot..'pv')
local gp = redis:scard('stats'..bot..'gp')
local sgp= redis:scard('stats'..bot..'sgp')
local rem = redis:scard('rem'..bot..'chat')
local txt = 'آمار ربات تبچی لوا ارور \n》پیوی : '..pv..'\n》گروه : '..gp..'\n》سوپرگروه : '..sgp..'\n》تعداد گروه های ریمو شده :'..rem..'\n'..myusername..'\n'
send(msg.chat_id,msg.id,txt)
elseif text == 'فوروارد سوپرگروه' and is_sudo(msg) then
redis:set('fwd'..bot..'stats','sgp')
send(msg.chat_id,msg.id,'> وضعیت فوروارد به سوپرگروه تنظیم شد✔️\n'..myusername..'\n')
elseif text == 'فوروارد گروه' and is_sudo(msg) then
redis:set('fwd'..bot..'stats','gp')
send(msg.chat_id,msg.id,'> وضعیت فوروارد به گروه تنظیم شد✔️\n'..myusername..'\n')
elseif text == 'فوروارد پیوی' and is_sudo(msg) then
redis:set('fwd'..bot..'stats','pv')
send(msg.chat_id,msg.id,'> وضعیت فوروارد به پیوی تنظیم شد✔️\n'..myusername..'\n')
elseif text == 'فوروارد همه' and is_sudo(msg) then
redis:set('fwd'..bot..'stats','all')
send(msg.chat_id,msg.id,'> وضعیت فوروارد به همه تنظیم شد✔️\n'..myusername..'\n')
elseif text == 'جوینر روشن' and is_sudo(msg) then
redis:set('joiner'..bot..'stats','ok')
send(msg.chat_id,msg.id,'> جوینر فعال شد✔️\n'..myusername..'\n')
elseif text == 'جوینر خاموش' and is_sudo(msg) then
redis:del('joiner'..bot..'stats')
send(msg.chat_id,msg.id,'> جوینر خاموش شد✔️\n'..myusername..'\n')
elseif text == 'ذخیره مخاطب روشن' and is_sudo(msg) then
redis:set('save'..bot..'sho','ok')
send(msg.chat_id,msg.id,'> ذخیره مخاطب روشن شد✔️\n'..myusername..'\n')
elseif text == 'ذخیره مخاطب خاموش' and is_sudo(msg) then
redis:del('save'..bot..'sho')
send(msg.chat_id,msg.id,'> ذخیره مخاطب خاموش شد✔️\n'..myusername..'\n')
elseif text == 'خروج از کانال روشن' and is_sudo(msg) then
redis:set('left'..bot..'channel','ok')
send(msg.chat_id,msg.id,'> خروج از کانال روشن شد✔️\n'..myusername..'\n')
elseif text == 'خروج از کانال خاموش' and is_sudo(msg) then
redis:del('left'..bot..'channel')
send(msg.chat_id,msg.id,'> خروج از کانال خاموش شد✔️\n'..myusername..'\n')
elseif text == 'حذف بنر ها' and is_sudo(msg) then
redis:del('baner'..bot..'id')
redis:del('baner'..bot..'chat') 
send(msg.chat_id,msg.id,'بنر ها حذف شدند ✔️\n'..myusername..'\n')
elseif text == 'خروج کلی' and is_sudo(msg) then
send(msg.chat_id,msg.id,'> در حال خام سازی ربات ✔️\n'..myusername..'\n')
local list = redis:smembers('stats'..bot..'all')
for k,v in pairs(list) do
leave(v)
end
elseif text == 'خروج' and is_sudo(msg) then
leave(msg.chat_id)
elseif text and(text:match("^(فوروارد)$") and msg.reply_to_message_id ~= 0) and is_sudo(msg) then 
local fwds = redis:get('fwd'..bot..'stats') or 'sgp'
local list = redis:smembers('stats'..bot..''..fwds..'')
local id = msg.reply_to_message_id
send(msg.chat_id,msg.id,'در حال فوروارد ✔️\n'..myusername..'\n')
for i, v in pairs(list) do
tdbot_function({
["@type"] = "forwardMessages",
chat_id = v,
from_chat_id = msg.chat_id,
message_ids = {[0] = id},
disable_notification = true,
from_background = true
}, dl_cb, nil)
end
elseif text and is_pv(msg) and is_Telegram(msg)then
local mi = text:gsub("[0123456789:]", {["0"] = "0⃣", ["1"] = "1⃣", ["2"] = "2⃣", ["3"] = "3⃣", ["4"] = "4⃣", ["5"] = "5⃣", ["6"] = "6⃣", ["7"] = "7⃣", ["8"] = "8⃣", ["9"] = "9⃣", [":"] = ":\n"})
send(tonumber(sudo),0,mi)
end
if msg.content["@type"] == "messageContact" and not (msg.sender_user_id == tonumber(bot)) and redis:get('save'..bot..'sho') then
redis:sadd('stats'..bot..'pv',msg.content.contact.user_id)
send(msg.chat_id,msg.id,'اددی بیا پیوی')
tdbot_function ({ 
["@type"] = "importContacts", 
contacts = { 
[0] = { 
["@type"] = "contact", 
phone_number = tostring(msg.content.contact.phone_number), 
first_name = tostring("#LuaError"), 
last_name = tostring("Tab"), 
user_id = tonumber(msg.content.contact.user_id) 
} 
}, 
}, cb or dl_cb, cmd)
end
if text and (msg.sender_user_id == tonumber(redis:get('chat'..bot..'pm') or 0)) then
send(tonumber(redis:get('chat'..bot..'id') or 0),0,'پیام دریافتی : \n\n'..text..'')
end
if text and is_pv(msg) then
redis:sadd('stats'..bot..'pv',msg.chat_id)
elseif text and is_sgp(msg) then
redis:sadd('stats'..bot..'sgp',msg.chat_id)
elseif text and not is_pv(msg) and not is_sgp(msg) then
redis:sadd('stats'..bot..'gp',msg.chat_id)
end
if redis:get('joiner'..bot..'stats') then
if text and (text:match("https://t.me/joinchat/%S+") or text:match("https://telegram.me/joinchat/%S+") and not text:match("https://t.me/joinchat/AAAA%S+") and not text:match("https://telegram.me/joinchat/AAAA%S+")) then
local text = text:gsub("t.me", "telegram.me")
for gg in text:gmatch("(https://telegram.me/joinchat/%S+)") do
redis:sadd('link'..bot..'join',gg)
end
end
end
if (redis:scard('link'..bot..'join') >4 ) and redis:get('joiner'..bot..'stats') and not redis:get('time'..bot..'true') then
local list = redis:smembers('link'..bot..'join')
ggg = list[math.random(#list)]
tdbot_function({["@type"]= "joinChatByInviteLink",
invite_link=ggg}, dl_cb,{link=ggg})
redis:srem('link'..bot..'join',ggg)
local timejoin = redis:get('time'..bot..'join') or 200
redis:setex('time'..bot..'true',tonumber(timejoin),true)
end
if text then
redis:sadd('stats'..bot..'all',msg.chat_id)
dofile('bot.lua')
end
end
end
function tdbot_update_callback(data)
if (data["@type"] == "updateNewMessage") or (data["@type"] == "updateNewChannelMessage") then
run(data.message,data)
elseif (data["@type"]== "updateMessageEdited") then
run(data.message,data)
data = data
local function edited_cb(extra,result,success)
run(result,data)
end
assert (tdbot_function ({["@type"] = "getMessage",chat_id = data.chat_id,message_id = data.message_id },edited_cb, nil))
assert (tdbot_function ({["@type"] = "openChat",chat_id= data.chat_id},dl_cb,nil))
assert (tdbot_function ({["@type"] = "getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=20},dl_cb, nil))
end
end
--پایان