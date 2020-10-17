import scala.io.Source
import scala.collection.mutable.ArrayBuffer
import java.io._
object scc {
  var n=0 //노드의 수
  var m=0 //간선의 수
  var ar=new ArrayBuffer[ArrayBuffer[Int]]() //순방향 그래프의 정보를 저장할 변수
  var rar=new ArrayBuffer[ArrayBuffer[Int]]() //역방향 그래프의 정보를 저장할 변수
  var stk=new ArrayBuffer[Int]() //스택과 스택의 크기를 저장할 변수
  var stk_size=0
  var visit=new ArrayBuffer[Boolean]() //dfs탐색중 이미 방문한 노드를 검사하기위한 변수
  var cycle=new ArrayBuffer[ArrayBuffer[Int]]() //묶어준 사이클 결과를 저장하고,사이클수를 저장하기 위한 변수
  var cycle_cnt=0
  var order=new ArrayBuffer[Int]() //사이클들을 소트할때 위치를 기억하기위한 변수
  def scannum(data: String) = { //한줄씩 입력받은 문자열을 두개의 숫자로 반환하여 주는 함수
    var len = data.length() //data의 길이를 저장하는 변수
    var a = 0 //두개의 숫자를 반환할 a,b
    var b = 0
    var first = true //첫번째 숫자인지 두번째 숫자인지 구별하기 위한 변수
    for (i <- 0 until len) {
      var next=data.charAt(i).toInt //문자로 된 데이터를 숫자로 치환
      next-='0'.toInt //숫자로 치환하면 코드값으로 되어있으므로 int형 의미로 만들어주기위해 '0'을 빼어줌
      if (first) { //첫번째 숫자를 입력받는경우 a에 첫번째 숫자를 만들어준다.
        if(next>=0 && next<=9) {
          a=a*10+next
        }
        else first=false
      }
      else { //두번째 숫자를 입력받는경우 b에 두번째 숫자를 만들어준다.
        if(next>=0 && next<=9) {
          b=b*10+next
        }
      }
    }
    (a, b) //두개 숫자 a,b 반환
  }
  def init(): Unit = { //노드의 수 n이 결정되면 ar과 rar이 n개의 공간을 갖도록 하기위한 함수
    for(i<-0 until n+1) {
      var temp = new ArrayBuffer[Int]()
      var temp2 = new ArrayBuffer[Int]()
      ar+=temp
      rar+=temp2
      visit+=false
    }
  }
  def initvisit(): Unit = { //visit를 모두 false로 초기화하는 함수
    for(i<-1 until n+1) visit(i)=false
  }
  def push(x: Int): Unit = { //stack의 push
    if(stk_size==stk.length) { //동적으로 확장된 스택이 더이상의 메모리 공간이 없을때 공간을 확장
      stk+=x
    }
    else stk(stk_size)=x
    stk_size+=1
  }
  def pop() = { //stack의 pop
    stk_size-=1
    stk(stk_size)
  }
  def dfs(x: Int): Unit = { //dfs 순반향 탐색을 하며 탐색이 끝난순으로 stack에 노드들을 push해준다.
    visit(x)=true
    for(next<-ar(x)) {
      if(!visit(next)) dfs(next)
    }
    push(x)
  }
  def rdfs(x: Int): Unit = { //dfs 역방향 탐색을 하며 같은 사이클에 속한 노드들을 저장한다
    visit(x)=true
    cycle(cycle_cnt)+=x
    for(next<-rar(x)) {
      if(!visit(next)) rdfs(next)
    }
  }
  def scc_func(): Unit = { //scc의 메인 함수
    initvisit()
    for(i<-1 until n+1) { //순방향 dfs호출
      if(!visit(i)) dfs(i)
    }
    initvisit()
    while(stk_size>0) { //스택에서 pop되는 노드순으로 역방향 dfs호출
      var next=pop()
      if(!visit(next)) {
        var temp = new ArrayBuffer[Int]() //새로운 사이클이 생기면 사이클 배열을 확장해준다
        cycle+=temp
        rdfs(next)
        cycle_cnt+=1
      }
    }
  }
  def quick_sort(index: Int,left: Int,right: Int): Unit = { //같은 사이클에 속한 노드를 퀵정렬
    var pivot=cycle(index)(left)
    var l = left
    var r = right
    while (l<=r) {
      while (pivot > cycle(index)(l)) l+=1
      while (pivot < cycle(index)(r)) r-=1
      if(l<=r) {
        var temp=cycle(index)(l); cycle(index)(l)=cycle(index)(r); cycle(index)(r)=temp
        l+=1; r-=1
      }
    }
    if(left<r) quick_sort(index,left,r)
    if(l<right) quick_sort(index,l,right)
  }
  def quick_sort2(left: Int,right: Int): Unit = { //사이클들을 첫번째 노드를 기준으로 퀵정렬
    var pivot=cycle(order(left))(0)
    var l = left
    var r = right
    while (l<=r) {
      while (pivot > cycle(order(l))(0)) l+=1
      while (pivot < cycle(order(r))(0)) r-=1
      if(l<=r) {
        var temp=order(l); order(l)=order(r); order(r)=temp
        l+=1; r-=1
      }
    }
    if(left<r) quick_sort2(left,r)
    if(l<right) quick_sort2(l,right)
  }
  def main(args: Array[String]): Unit = {
    var first=true
    for(data<-Source.fromFile("input.txt").getLines()) { //데이터를 한줄씩 문자열 형태로 입력받음
      var (a, b) = scannum(data) //scannum 함수를 통해 a,b에 입력된 숫자 저장
      if (first) { //첫번째줄은 노드수와 간선수를 입력받음
        n = a
        m = b
        init()
        first = false
      }
      else { //다음번째 줄부터 간선의 정보를 입력받음
        ar(a) += b
        rar(b) += a
      }
    }
    scc_func() //scc 알고리즘을 수행
    for(i<-0 until cycle_cnt) { //사이클에 속한 노드들을 정렬함
      quick_sort(i,0,cycle(i).length-1)
      order+=i
    }
    quick_sort2(0,cycle_cnt-1) //사이클들을 첫번째 노드의 번호를 기준으로 정렬함
    val file=new File("output.txt") //파일출력을 위해 file을 저장
    val out=new BufferedWriter(new FileWriter(file)) //file writer 선언
    out.write("number of cycles : ") //사이클의 수와 각각의 사이클에 속한 노드들을 출력해줌
    out.write(cycle_cnt.toString()+" \n")
    println("number of cycles : "+cycle_cnt)
    for(i<-0 until cycle_cnt) {
      out.write((i+1).toString())
      out.write("th members : ")
      print((i+1)+"th members : ")
      for(next<-cycle(i)) {
        out.write(next.toString())
        out.write(" ")
        print(next+" ")
      }
      out.write("\n")
      println()
    }
    out.write("2013210109 김형준")
    print("2013210109 김형준")
    out.close()
}
}
