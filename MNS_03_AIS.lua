ini=false
on=false
io={}
io.gN,io.gB,io.sN,io.sB=input.getNumber,input.getBool,output.setNumber,output.setBool
s={}
s.drf,s.dr,s.dtf,s.dt,s.dtb,s.sc,s.dl=screen.drawRectF,screen.drawRect,screen.drawTriangleF,screen.drawText,screen.drawTextBox,screen.setColor,screen.drawLine
m={ms=map.mapToScreen}
rxFreq=201
txFreq=0
extID=false

function onTick()
  on=io.gB(1)
  if not extID then txFreq = io.gN(14) end
  
  if on and ini then
    cX,cY=io.gN(1),io.gN(2)
    zoom=io.gN(3)
    gX,gY=io.gN(4),io.gN(5)
    speed = io.gN(6)
    heading = io.gN(7)
    
    
    if heading < 0 then
			headD = (math.abs(heading))*360
		elseif heading == 0 then
      headD = 0
    else
			headD = 360-heading*360
		end
    
    send(txFreq)
    receive(txFreq)
    io.sN(1,rxFreq)
    io.sN(2,txFreq)
    
    extTXFreq = io.gN(15)
    if extTXFreq >= 201 and extTXFreq <= 230 and isInteger(extTXFreq) then
      extID=true
      txFreq = extTXFreq
      if rxFreq == txFreq then incrementRX() end
    else
      extID=false
    end
    
  else
    io.sN(5,0)
  end
end

function send(freq)
  io.sN(3,gX)
  io.sN(4,gY)
  io.sN(5,freq)
  io.sN(6,speed)
  io.sN(7,headD)
end

function receive()
  rX,rY = io.gN(8),io.gN(9)
  rid = io.gN(10)
  rsp = io.gN(11)
  rhd = io.gN(12)
  rname = io.gN(13)
  
  if rid == 0 then --no input received on freq
    if contacts[rxFreq] ~= nil then
      contacts[rxFreq].age = contacts[rxFreq].age+1
      if contacts[rxFreq].age > 500 then contacts[rxFreq] = nil end
    end
  else
    if contacts[rid] == nil then
      if rname == 0 then
        addContact(rX,rY,rid,rsp,rhd)
      else
        addContact(rX,rY,rid,rsp,rhd,rname)
      end
    else
      updateContact(rid,rX,rY,rsp,rhd)
    end
  end
  
  incrementRX()
end

function incrementRX()
  rxFreq = rxFreq+1
  if rxFreq == txFreq then rxFreq = rxFreq+1 end
  if rxFreq > 230 then rxFreq = 201 end
  if rxFreq == txFreq then rxFreq = rxFreq+1 end
end

function isInteger(nr)
  return nr == math.floor(nr)
end

function updateContact(id,x,y,speed,hd)
  contacts[id].x = x
  contacts[id].y = y
  contacts[id].speed = speed
  contacts[id].hd = hd
  contacts[id].age = 0
end

function addContact(x,y,id,speed,hd,name)
  local data = {
		['x']=(x),
		['y']=(y),
    ['id']=(id),
		['speed']=(speed or 0),
		['hd']=(hd or 0),
		['name']=(name or "Unknown"),
    ['age']=(0)
	}
	contacts[id]=data
end

function init()
  if not contacts then contacts={} end
  center={x=w/2, y=h/2}
  f=h/32
  
  if txFreq >= 201 and txFreq <= 230 then
    ini = true
    if txFreq == 201 then rxFreq = 202 end
  end
end

function onDraw()
  w = screen.getWidth()
	h = screen.getHeight()
  if not ini then init() end
  
  if on then
    if not ini then 
      s.dt(f,center.y-f,"Invalid ID")
    else
  
      for k,c in pairs(contacts) do
        drawX,drawY = m.ms(cX,cY,zoom,w,h,c.x,c.y)
        if c.age <=1 then
          s.sc(0,70,0,200)
        elseif c.age <= 30 then
          s.sc(50,50,0,200)
        else
          s.sc(50,0,0,200)
        end
        s.dr(drawX-1,drawY-1,2,2)
        s.sc(160,160,160,100)
        spV=c.speed/30
        spV=spV*(h*2/5)
        vX=math.sin(math.rad(c.hd))
        vY=math.cos(math.rad(c.hd))
        vX=vX*spV;vY=vY*spV
        s.dl(drawX,drawY,drawX+vX,drawY-vY)
      end
  
    end
  end
end