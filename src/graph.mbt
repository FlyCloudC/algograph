///|
pub fn Graph::new[A](capacity~ : Int = 0) -> Graph[A] {
  { datas: Array::new(capacity~), edges: Array::new(capacity~) }
}

///|
pub fn Graph::make[A](len : Int, elem : A) -> Graph[A] {
  { datas: Array::make(len, elem), edges: Array::makei(len, fn(_) { [] }) }
}

///|
pub fn Graph::from_datas[A](datas : Array[A]) -> Graph[A] {
  { datas, edges: datas.map(fn(_) { [] }) }
}

///|
pub fn push[A](self : Graph[A], data : A) -> Int {
  self.edges.push([])
  self.datas.push(data)
  self.datas.length() - 1
}

///| require: id is valid
pub fn data[A](self : Graph[A], id : Int) -> A {
  self.datas[id]
}

///| require: id is valid
pub fn add_edge[A](self : Graph[A], from : Int, to : Int) -> Unit {
  self.edges[from].push(to)
}

///| require: id is valid
pub fn add_edge_both[A](self : Graph[A], a : Int, b : Int) -> Unit {
  self.add_edge(a, b)
  self.add_edge(b, a)
}

///|
pub fn node_count[A](self : Graph[A]) -> Int {
  self.datas.length()
}
