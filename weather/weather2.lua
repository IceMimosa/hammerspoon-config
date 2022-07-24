-- local urlApi = 'https://api2.jirengu.com/getWeather.php?city=%E4%B8%8A%E6%B5%B7' -- 上海
local urlApi = 'http://api2.jirengu.com/getWeather.php?city=%E4%B8%8A%E6%B5%B7' -- 上海
local menubar = hs.menubar.new()
local menuData = {}

local weaEmoji = {
   default = ''
}
weaEmoji['雷'] = '⛈'
weaEmoji['雷阵雨'] = '⛈'
weaEmoji['晴'] = '☀️'
weaEmoji['沙尘'] = '😷'
weaEmoji['雾'] = '🌫'
weaEmoji['雪'] = '❄️'
weaEmoji['阵雪'] = '❄️'
weaEmoji['小雪'] = '❄️'
weaEmoji['中雪'] = '❄️'
weaEmoji['大雪'] = '❄️'
weaEmoji['暴雪'] = '❄️'
weaEmoji['雨'] = '🌧'
weaEmoji['阵雨'] = '🌧'
weaEmoji['小雨'] = '🌧'
weaEmoji['中雨'] = '🌧'
weaEmoji['大雨'] = '🌧'
weaEmoji['暴雨'] = '🌧'
weaEmoji['大暴雨'] = '🌧'
weaEmoji['特大暴雨'] = '🌧'
weaEmoji['雨夹雪'] = '🌨'
weaEmoji['多云'] = '☁️'
weaEmoji['阴'] = '⛅️'

function updateMenubar()
	 menubar:setTooltip("Weather Info")
    menubar:setMenu(menuData)
end

function getWeather()
   hs.http.doAsyncRequest(urlApi, "GET", nil, nil, function(code, body, htable)
      if code ~= 200 then
         print('get weather error:'..code)
         return
      end
      rawjson = hs.json.decode(body)
      -- print(inspect(rawjson))
      location = rawjson.result.location
      now = rawjson.result.now
      forecasts = rawjson.result.forecasts
      city = location.city
      print(city)
      menuData = {}
      for k, v in pairs(forecasts) do
         if k == 1 then
            menubar:setTitle(weaEmoji[now.text])
            titlestr = string.format("%s %s %s 🌡️%s 💧%s 💨%s 🌬 %s %s", city, weaEmoji[now.text], v.week, now.temp, now.rh, now.wind_dir, now.wind_class, now.text)
            item = { title = titlestr }
            table.insert(menuData, item)
            table.insert(menuData, {title = '-'})
         else
            -- titlestr = string.format("%s %s %s %s", v.day, v.wea, v.tem, v.win_speed)
            titlestr = string.format("%s %s %s 🌡️%s 💨%s 🌬%s %s", city, weaEmoji[v.text_day], v.week, v.low..'-'..v.high, v.wd_day, v.wc_day, v.text_day..'-'..v.text_night)
            item = { title = titlestr }
            table.insert(menuData, item)
         end
      end
      updateMenubar()
   end)
end

menubar:setTitle('⌛')
getWeather()
updateMenubar()
weatherTimer = hs.timer.new(3600, getWeather)
weatherTimer:start()
-- hs.timer.doEvery(3600, getWeather)
