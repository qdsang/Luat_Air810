module(...,package.seeall)
--[[
模块名称：通话测试
模块功能：测试呼入呼出
模块最后修改时间：2017.02.23
]]

require"audio"
require"cc"

--默认呼叫的电话号码
local phone_number = "10086"

--[[
函数名：print
功能  ：打印接口，此文件中的所有打印都会加上test前缀
参数  ：无
返回值：无
]]
local function print(...)
	_G.print("test",...)
end

--[[
函数名：connected
功能  ：“通话已建立”消息处理函数
参数  ：无
返回值：无
]]
local function connected()
	print("connected")
	--设置mic增益
	audio.setmicrophonegain(7)
	--10秒钟之后主动结束通话
	sys.timer_start(cc.hangup,10000,"AUTO_DISCONNECT")
end

--[[
函数名：disconnected
功能  ：“通话已结束”消息处理函数
参数  ：
		para：通话结束原因值
			  "LOCAL_HANG_UP"：用户主动调用cc.hangup接口挂断通话
			  "CALL_FAILED"：用户调用cc.dial接口呼出，at命令执行失败
			  "NO CARRIER"：呼叫无应答
			  "BUSY"：占线
			  "NO ANSWER"：呼叫无应答
返回值：无
]]
local function disconnected(para)
	print("disconnected:"..(para or "nil"))
	sys.timer_stop(cc.hangup,"AUTO_DISCONNECT")
end

--[[
函数名：incoming
功能  ：“来电”消息处理函数
参数  ：
		num：string类型，来电号码
返回值：无
]]
local function incoming(num)
	print("incoming:"..num)
	--接听来电
	cc.accept()
end

--[[
函数名：ready
功能  ：“通话功能模块准备就绪”消息处理函数
参数  ：无
返回值：无
]]
local function ready()
	print("ready")
	--呼叫phone_number
	cc.dial(phone_number)
end

--注册消息的用户回调函数
cc.regcb("READY",ready,"INCOMING",incoming,"CONNECTED",connected,"DISCONNECTED",disconnected)
