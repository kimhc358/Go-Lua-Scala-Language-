package main

import (
	"fmt"
	"os"
	"sort"
)
type Cycle_struct struct { //Go에서 제공하는 정렬 library를 사용하기 위해 구조체로 cycle을 구성
	member[] int
}
type Cycles []Cycle_struct //Go에서 제공하는 정렬 library를 사용하기 위해 구조체 선언
var cycle[] Cycle_struct //묶어준 사이클 결과를 저장할 변수
var ar[10001][] int //순방향 그래프의 정보를 저장할 변수
var rar[10001][] int //역방향 그래프의 정보를 저장할 변수
var visit[10001] bool //dfs탐색중 이미 방문한 노드를 검사하기위한 변수
var stk[10001] int //스택
var n,m,stk_size,cycle_cnt int //각각 변수의 크기를 저장해줄 변수
func init_visit() { //visit를 모두 false로 초기화하는 함수
	for i:=1 ; i<=n ; i++ {
		visit[i]=false
	}
}
func push(val int) { //stack의 push
	stk[stk_size]=val
	stk_size++
}
func pop() int { //stack의 pop
	stk_size--
	return stk[stk_size]
}
func dfs(x int) { //dfs 순반향 탐색을 하며 탐색이 끝난순으로 stack에 노드들을 push해준다.
	visit[x]=true
	for _, next:=range ar[x] {
		if(!visit[next]) {
			dfs(next)
		}
	}
	push(x)
}
func rdfs(x int) { //dfs 역방향 탐색을 하며 같은 사이클에 속한 노드들을 저장한다
	visit[x]=true
	cycle[cycle_cnt].member=append(cycle[cycle_cnt].member,x)
	for _, next:=range rar[x] {
		if(!visit[next]) {
			rdfs(next)
		}
	}
}
func scc() { //scc의 메인 함수
	init_visit()
	for i:=1 ; i<=n ; i++ { //순방향 dfs호출
		if(!visit[i]) {
			dfs(i)
		}
	}
	init_visit()
	for stk_size>0 { //스택에서 pop되는 노드순으로 역방향 dfs호출
		next:=pop()
		if(!visit[next]) {
			cycle=append(cycle,Cycle_struct{}) //새로운 사이클이 생기면 사이클 배열을 확장해준다
			rdfs(next)
			cycle_cnt++
		}
	}
}
func(s Cycles) Len() int { //Go에서 제공하는 정렬 library를 사용하기 위한 함수 3개. 정렬할 변수의 크기와 정렬 방법을 알려준다.
	return cycle_cnt
}
func(s Cycles) Swap(i,j int) {
	s[i],s[j]=s[j],s[i]
}
func(s Cycles) Less(i,j int) bool {
	return s[i].member[0]<s[j].member[0]
}
func main() {
	in, _ := os.Open("input.txt")
	defer in.Close()
	out, _ := os.Create("output.txt")
	defer out.Close()
	fmt.Fscan(in,&n,&m) //그래프의 정보를 입력받는다
	for i :=0; i<m ; i++ {
		var a,b int
		fmt.Fscan(in,&a,&b)
		ar[a]=append(ar[a],b)
		rar[b]=append(rar[b],a)
	}
	scc() //scc알고리즘을 수행
	for i:=0 ; i<cycle_cnt ; i++ { //사이클에 속한 노드들을 Go에서 제공하는 정렬 library로 정렬함
		sort.Sort(sort.IntSlice(cycle[i].member))
	}
	sort.Sort(Cycles(cycle)) //사이클들을 첫번째 노드의 번호를 기준으로 정렬함
	fmt.Fprintln(out,"number of cycles : ",cycle_cnt) //사이클의 수와 각각의 사이클에 속한 노드들을 출력해줌
	fmt.Println("number of cycles :",cycle_cnt)
	for i:=0 ; i<cycle_cnt ; i++ {
		fmt.Fprint(out,i+1,"th members : ")
		fmt.Print(i+1,"th members : ")
		for _, next:=range cycle[i].member {
			fmt.Fprint(out,next," ")
			fmt.Print(next," ")
		}
		fmt.Fprintln(out)
		fmt.Println()
	}
	fmt.Fprintln(out,"2013210109 Kim Hyung Jun")
	fmt.Println("2013210109 Kim Hyung Jun")
}