function scannum() //��ü�� �Է¹��� ���ڿ����� ���ڸ� �ϳ��� ��ȯ���ִ� �Լ�
	local get=false //���ڸ� �д� �������� ������ ����
	local num=0 //��ȯ�� ��
	while datahandle<=datalen do //���� �о���� ��ġ���� ���ڿ��� �о��
		local next=tonumber(string.sub(data,datahandle,datahandle)) //datahandle ��ġ�� ���ڸ� ������ ���ڷ� ġȯ�Ͽ���
		if next and next>=0 and next<=9 then //���ڸ� �Է¹޴� ���
			num=num*10+next
			get=true
		elseif get then //���ڰ� �ƴѰ��� �Է¹޾Ҵµ�, �̹� ���ڸ� �Է¹޾����� ���ڸ� ��ȯ�Ͽ���
			return num
		end
		datahandle=datahandle+1
	end
	if get then return num end //���ڸ� �Է¹��� ���Ѱ�� nil�� ��ȯ�Ͽ��� �Է� �����Ͱ� �����̸� �Ͼ�� ����
	return nil
end

function init_visit() //visit�� ��� false�� �ʱ�ȭ�ϴ� �Լ�
	for i=1,n do
		visit[i]=false
	end
end

function push(x) //stack�� push
stk_size=stk_size+1
stk[stk_size]=x;
end

function pop() //stack�� pop
local val=stk[stk_size]
stk[stk_size]=nil
stk_size=stk_size-1
return val
end

function dfs(x) //dfs ������ Ž���� �ϸ� Ž���� ���������� stack�� ������ push���ش�.
	visit[x]=true
	for _,next in pairs(ar[x]) do
		if visit[next]==false then
			dfs(next)
		end
	end
	push(x)
end

function rdfs(x) //dfs ������ Ž���� �ϸ� ���� ����Ŭ�� ���� ������ �����Ѵ�
	visit[x]=true
	cycle_size[cycle_cnt]=cycle_size[cycle_cnt]+1
	cycle[cycle_cnt][cycle_size[cycle_cnt]]=x
	for _,next in pairs(rar[x]) do
		if visit[next]==false then
			rdfs(next)
		end
	end
end

function scc() //scc�� ���� �Լ�
	visit={}
	stk={}
	stk_size=0
	init_visit()
	for i=1,n do //������ dfsȣ��
		if visit[i]==false then
			dfs(i)
		end
	end
	init_visit()
	cycle={}
	cycle_cnt=0
	cycle_size={}
	while(stk_size>0) do //���ÿ��� pop�Ǵ� �������� ������ dfsȣ��
		next=pop()
		if visit[next]==false then
			cycle_cnt=cycle_cnt+1
			cycle[cycle_cnt]={} //�������� cycle Ȯ��
			cycle_size[cycle_cnt]=0
			rdfs(next)
		end
	end
end
function cmp(i,j) //����Ŭ���� ù��° ��� ������ �����ϱ� ���� �Լ� lua�� sort library�� ���Ĵ�� boolean Ÿ������ ��ȯ�Ͽ���
	return cycle[i][1]<cycle[j][1]
end
local input=io.open("input.txt","r") //input.txt���� �Է��� ����
local output=io.open("output.txt","w") //output.txt���� �Է��� ����
if input then //data������ ��ü �Էµ� �����͸� �޴´�
	data=input:read("*all")
	input:close()
end
datalen=string.len(data) //�������� �� ����
datahandle=1
n=scannum() //scannum �Լ��� �̿��� ���ڸ� �ϳ��� �����´�
m=scannum()
ar={} //������ �׷����� ������ ������ ����.
ar_size={} //�� ��帶�� ��� ������ ������ table���¿����� Ȯ���� �����Ƿ� ������ ��忡 ��� ������ �ִ��� ������ ����
rar={} //������ �׷����� ������ ������ ����
rar_size={}
for i=1,n do //ar�� rar�� ����� ���� n��ŭ Ȯ������
	ar[i]={}
	ar_size[i]=0
	rar[i]={}
	rar_size[i]=0
end
for i=1,m do //������ �Է¹���
	local a=scannum()
	local b=scannum()
	ar_size[a]=ar_size[a]+1
	ar[a][ar_size[a]]=b
	rar_size[b]=rar_size[b]+1
	rar[b][rar_size[b]]=a
end
scc() //scc �˰����� ����
order={} //����Ŭ���� ��Ʈ�Ҷ� ��ġ�� ����ϱ����� ����
for i=1,cycle_cnt do //����Ŭ�� ���� ������ ������ lua���� �����ϴ� sort library�� �����
	table.sort(cycle[i])
	order[i]=i
end
table.sort(order,cmp) //����Ŭ���� ù��° ����� ��ȣ�� �������� ������

output:write("number of cycles : ",cycle_cnt,'\n') //output.txt�� ����Ŭ�� ���� ������ ����Ŭ�� ���� ������ �������
for i=1,cycle_cnt do
	output:write(i,"th members : ")
	for _,member in pairs(cycle[order[i]]) do
		output:write(member,' ')
	end
	output:write('\n')
end
output:write("2013210109 Kim Hyung Jun\n")
output:close()
