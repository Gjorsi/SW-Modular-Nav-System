ini,ini,extID,dNames=false,false,false,false
io={}
io.gN,io.gB,io.sN=input.getNumber,input.getBool,output.setNumber
s={}
s.dr,s.dt,s.sc,s.dl=screen.drawRect,screen.drawText,screen.setColor,screen.drawLine
m={ms=map.mapToScreen}
rxF=201
txF=0
ti=0
rec={0,0,0,0}
n={0,0,0,0}
alphabet={'Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','G','H','J','K','L','Z','X','C','V','B','N','M'}

function onTick()
  on=io.gB(1)
  if not extID then txF = io.gN(17) end
  
  if on and ini then

    cX,cY=io.gN(1),io.gN(2)
    zoom=io.gN(3)
    gX,gY=io.gN(4),io.gN(5)
    speed = io.gN(6)
    hd = io.gN(7)
    dNames = io.gB(2)
    
    -- convert heading to degrees
    if hd < 0 then hdD = (math.abs(hd))*360
		elseif hd == 0 then hdD = 0
    else hdD = 360-hd*360 end
    
    send(txF)
    rcv()
    io.sN(1,rxF)
    io.sN(2,txF)
    
    extTXFreq = io.gN(18)
    if extTXFreq >= 201 and extTXFreq <= 230 and isInt(extTXFreq) then
      extID=true
      txF = extTXFreq
      if rxF == txF then incrRX() end
    else
      extID=false
    end
    
    rec[1]=io.gN(19)
    if rec[1]>0 then
      rec[2]=io.gN(20)
      rec[3]=io.gN(21)
      rec[4]=io.gN(22)
      for i=1,4 do
        n[i]=rec[i]
      end
      name=dec(rec)
    end
  else
    io.sN(5,0)
  end
end

function dec(arr)
  local decoded=""
  for i=1,4 do
    if arr[i] > 0 then
      r = string.format("%d",arr[i])
      for j=1,#r,2 do
      decoded = decoded..deco[tonumber(r:sub(j,j+1))]
      end
    end
  end
  return decoded
end

function send(freq)
  io.sN(3,gX)
  io.sN(4,gY)
  io.sN(5,freq)
  io.sN(6,speed)
  io.sN(7,hdD)
  for i=1,4 do
    io.sN(7+i,n[i])
  end
end

function rcv()
  rX,rY = io.gN(8),io.gN(9)
  rid = io.gN(10)
  rsp = io.gN(11)
  rhd = io.gN(12)
  
  if rid == 0 then
    if cont[rxF] ~= nil then
      cont[rxF].age = cont[rxF].age+1
      if cont[rxF].age > 240 then cont[rxF] = nil end
    end
  else
    rname={io.gN(13),io.gN(14),io.gN(15),io.gN(16)}
    if cont[rid] == nil then
      addC(rX,rY,rid,rsp,rhd)
    else
      updC(rid,rX,rY,rsp,rhd)
    end
    if rname[1] ~= 0 then cont[rid].name = dec(rname) end
  end
  incrRX()
end

function incrRX()
  rxF = rxF+1
  if rxF == txF then rxF = rxF+1 end
  if rxF > 230 then rxF = 201 end
  if rxF == txF then rxF = rxF+1 end
end

function isInt(nr)
  return nr == math.floor(nr)
end

function updC(id,x,y,speed,hd)
  cont[id].x = x
  cont[id].y = y
  cont[id].speed = speed
  cont[id].hd = hd
  cont[id].age = 0
end

function addC(x,y,id,speed,hd,name)
  local data = {
		['x']=(x),
		['y']=(y),
    ['id']=(id),
		['speed']=(speed or 0),
		['hd']=(hd or 0),
		['name']=(name or "Unknown"),
    ['age']=(0)
	}
	cont[id]=data
end

function init()
  if not cont then cont={} end
  center={x=w/2, y=h/2}
  f=h/32
  
  deco={}
  for i=0,9 do
    deco[10+i]=string.format("%d",i)
  end
  for i=1,26 do
    deco[19+i]=alphabet[i]
  end
  
  if txF >= 201 and txF <= 230 then
    ini = true
    if txF == 201 then rxF = 202 end
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
      s.sc(80,0,0,150)
      if h>64 and name then s.dt(4,h-7,"N: "..name) end
      s.dt(center.x+4,h-6,string.format("ID%d",txF))
  
      for k,c in pairs(cont) do
        dX,dY = m.ms(cX,cY,zoom,w,h,c.x,c.y)
        if c.age <=2 then
          s.sc(0,70,0,200)
        elseif c.age <= 20 then
          s.sc(50,50,0,200)
        else
          s.sc(50,0,0,200)
        end
        if dNames then 
          s.dt(dX-#c.name*2,dY+4,c.name)
        end
        s.dr(dX-1,dY-1,2,2)
        s.sc(120,120,120,200)
        
        spV=c.speed/30
        spV=spV*(h*2/5)
        vX=math.sin(math.rad(c.hd))
        vY=math.cos(math.rad(c.hd))
        vX=vX*spV;vY=vY*spV
        s.dl(dX,dY,dX+vX,dY-vY)
      end
    end
  end
end