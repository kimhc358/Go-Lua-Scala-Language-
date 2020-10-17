package main

import (
	"fmt"
	"os"
	"sort"
)
type Cycle_struct struct {
	member[] int
}
type Cycles []Cycle_struct
var cycle[] Cycle_struct
var ar[10001][] int
var rar[10001][] int
var visit[10001] bool
var stk[10001] int
var n,m,stk_size,cycle_cnt int
func init_visit() {
	for i:=1 ; i<=n ; i++ {
		visit[i]=false
	}
}
func push(val int) {
	stk[stk_size]=val
	stk_size++
}
func pop() int {
	stk_size--
	return stk[stk_size]
}
func dfs(x int) {
	visit[x]=true
	for _, next:=range ar[x] {
		if(!visit[next]) {
			dfs(next)
		}
	}
	push(x)
}
func rdfs(x int) {
	visit[x]=true
	cycle[cycle_cnt].member=append(cycle[cycle_cnt].member,x)
	for _, next:=range rar[x] {
		if(!visit[next]) {
			rdfs(next)
		}
	}
}
func scc() {
	init_visit()
	for i:=1 ; i<=n ; i++ {
		if(!visit[i]) {
			dfs(i)
		}
	}
	init_visit()
	for stk_size>0 {
		next:=pop()
		if(!visit[next]) {
			cycle=append(cycle,Cycle_struct{})
			rdfs(next)
			cycle_cnt++
		}
	}
}
func(s Cycles) Len() int {
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
	fmt.Fscan(in,&n,&m)
	for i :=0; i<m ; i++ {
		var a,b int
		fmt.Fscan(in,&a,&b)
		ar[a]=append(ar[a],b)
		rar[b]=append(rar[b],a)
	}
	scc()
	for i:=0 ; i<cycle_cnt ; i++ {
		sort.Sort(sort.IntSlice(cycle[i].member))
	}
	sort.Sort(Cycles(cycle))
	fmt.Fprintln(out,"number of cycles : ",cycle_cnt)
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