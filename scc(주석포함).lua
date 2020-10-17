function scannum() //전체를 입력받은 문자열에서 숫자를 하나씩 반환해주는 함수
	local get=false //숫자를 읽는 중인지를 저장할 변수
	local num=0 //반환할 수
	while datahandle<=datalen do //현재 읽어야할 위치부터 문자열을 읽어나감
		local next=tonumber(string.sub(data,datahandle,datahandle)) //datahandle 위치의 문자를 가져와 숫자로 치환하여줌
		if next and next>=0 and next<=9 then //숫자를 입력받는 경우
			num=num*10+next
			get=true
		elseif get then //숫자가 아닌것을 입력받았는데, 이미 숫자를 입력받았으면 숫자를 반환하여줌
			return num
		end
		datahandle=datahandle+1
	end
	if get then return num end //숫자를 입력받지 못한경우 nil을 반환하여줌 입력 데이터가 정상이면 일어나지 않음
	return nil
end

function init_visit() //visit를 모두 false로 초기화하는 함수
	for i=1,n do
		visit[i]=false
	end
end

function push(x) //stack의 push
stk_size=stk_size+1
stk[stk_size]=x;
end

function pop() //stack의 pop
local val=stk[stk_size]
stk[stk_size]=nil
stk_size=stk_size-1
return val
end

function dfs(x) //dfs 순반향 탐색을 하며 탐색이 끝난순으로 stack에 노드들을 push해준다.
	visit[x]=true
	for _,next in pairs(ar[x]) do
		if visit[next]==false then
			dfs(next)
		end
	end
	push(x)
end

function rdfs(x) //dfs 역방향 탐색을 하며 같은 사이클에 속한 노드들을 저장한다
	visit[x]=true
	cycle_size[cycle_cnt]=cycle_size[cycle_cnt]+1
	cycle[cycle_cnt][cycle_size[cycle_cnt]]=x
	for _,next in pairs(rar[x]) do
		if visit[next]==false then
			rdfs(next)
		end
	end
end

function scc() //scc의 메인 함수
	visit={}
	stk={}
	stk_size=0
	init_visit()
	for i=1,n do //순방향 dfs호출
		if visit[i]==false then
			dfs(i)
		end
	end
	init_visit()
	cycle={}
	cycle_cnt=0
	cycle_size={}
	while(stk_size>0) do //스택에서 pop되는 노드순으로 역방향 dfs호출
		next=pop()
		if visit[next]==false then
			cycle_cnt=cycle_cnt+1
			cycle[cycle_cnt]={} //동적으로 cycle 확장
			cycle_size[cycle_cnt]=0
			rdfs(next)
		end
	end
end
function cmp(i,j) //사이클들을 첫번째 노드 순으로 정렬하기 위한 함수 lua의 sort library의 형식대로 boolean 타입으로 반환하여줌
	return cycle[i][1]<cycle[j][1]
end
local input=io.open("input.txt","r") //input.txt에서 입력을 받음
local output=io.open("output.txt","w") //output.txt에서 입력을 받음
if input then //data변수에 전체 입력된 데이터를 받는다
	data=input:read("*all")
	input:close()
end
datalen=string.len(data) //데이터의 총 길이
datahandle=1
n=scannum() //scannum 함수를 이용해 숫자를 하나씩 가져온다
m=scannum()
ar={} //순방향 그래프의 정보를 저장할 변수.
ar_size={} //각 노드마다 몇개의 간선을 가진지 table형태에서는 확인이 어려우므로 각각의 노드에 몇개의 간선이 있는지 저장할 변수
rar={} //역방향 그래프의 정보를 저장할 변수
rar_size={}
for i=1,n do //ar과 rar을 노드의 수인 n만큼 확장해줌
	ar[i]={}
	ar_size[i]=0
	rar[i]={}
	rar_size[i]=0
end
for i=1,m do //간선을 입력받음
	local a=scannum()
	local b=scannum()
	ar_size[a]=ar_size[a]+1
	ar[a][ar_size[a]]=b
	rar_size[b]=rar_size[b]+1
	rar[b][rar_size[b]]=a
end
scc() //scc 알고리즘을 수행
order={} //사이클들을 소트할때 위치를 기억하기위한 변수
for i=1,cycle_cnt do //사이클에 속한 노드들을 정렬함 lua에서 제공하는 sort library를 사용함
	table.sort(cycle[i])
	order[i]=i
end
table.sort(order,cmp) //사이클들을 첫번째 노드의 번호를 기준으로 정렬함

output:write("number of cycles : ",cycle_cnt,'\n') //output.txt에 사이클의 수와 각각의 사이클에 속한 노드들을 출력해줌
for i=1,cycle_cnt do
	output:write(i,"th members : ")
	for _,member in pairs(cycle[order[i]]) do
		output:write(member,' ')
	end
	output:write('\n')
end
output:write("2013210109 Kim Hyung Jun\n")
output:close()
