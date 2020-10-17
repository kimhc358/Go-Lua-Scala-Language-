function scannum()
	local get=false
	local num=0
	while datahandle<=datalen do
		local next=tonumber(string.sub(data,datahandle,datahandle))
		if next and next>=0 and next<=9 then
			num=num*10+next
			get=true
		elseif get then
			return num
		end
		datahandle=datahandle+1
	end
	if get then return num end
	return nil
end

function init_visit()
	for i=1,n do
		visit[i]=false
	end
end

function push(x)
stk_size=stk_size+1
stk[stk_size]=x;
end

function pop()
local val=stk[stk_size]
stk[stk_size]=nil
stk_size=stk_size-1
return val
end

function dfs(x)
	visit[x]=true
	for _,next in pairs(ar[x]) do
		if visit[next]==false then
			dfs(next)
		end
	end
	push(x)
end

function rdfs(x)
	visit[x]=true
	cycle_size[cycle_cnt]=cycle_size[cycle_cnt]+1
	cycle[cycle_cnt][cycle_size[cycle_cnt]]=x
	for _,next in pairs(rar[x]) do
		if visit[next]==false then
			rdfs(next)
		end
	end
end

function scc()
	visit={}
	stk={}
	stk_size=0
	init_visit()
	for i=1,n do
		if visit[i]==false then
			dfs(i)
		end
	end
	init_visit()
	cycle={}
	cycle_cnt=0
	cycle_size={}
	while(stk_size>0) do
		next=pop()
		if visit[next]==false then
			cycle_cnt=cycle_cnt+1
			cycle[cycle_cnt]={}
			cycle_size[cycle_cnt]=0
			rdfs(next)
		end
	end
end
function cmp(i,j)
	return cycle[i][1]<cycle[j][1]
end
local input=io.open("input.txt","r")
local output=io.open("output.txt","w")
if input then
	data=input:read("*all")
	input:close()
end
datalen=string.len(data)
datahandle=1
n=scannum()
m=scannum()
ar={}
ar_size={}
rar={}
rar_size={}
for i=1,n do
	ar[i]={}
	ar_size[i]=0
	rar[i]={}
	rar_size[i]=0
end
for i=1,m do
	local a=scannum()
	local b=scannum()
	ar_size[a]=ar_size[a]+1
	ar[a][ar_size[a]]=b
	rar_size[b]=rar_size[b]+1
	rar[b][rar_size[b]]=a
end
scc()
order={}
for i=1,cycle_cnt do
	table.sort(cycle[i])
	order[i]=i
end
table.sort(order,cmp)

output:write("number of cycles : ",cycle_cnt,'\n')
for i=1,cycle_cnt do
	output:write(i,"th members : ")
	for _,member in pairs(cycle[order[i]]) do
		output:write(member,' ')
	end
	output:write('\n')
end
output:write("2013210109 Kim Hyung Jun\n")
output:close()
